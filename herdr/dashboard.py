#!/usr/bin/env python3
"""Live Codex/Claude screen previews for a Herdr popup (Python standard library).

Arrows/hjkl select, Enter focuses the agent, Esc/q returns without changing focus.
Uses the popup's inherited Herdr socket context; never resizes the source panes.
"""

import concurrent.futures
import curses
import json
import locale
import math
import os
import re
import shutil
import subprocess
import sys
import time
import unicodedata


REFRESH_SECONDS = 1.0
PREVIEW_REFRESH_SECONDS = 0.2
COMMAND_TIMEOUT = 2.0
AGENT_KINDS = {"codex", "claude"}
ANSI_ESCAPE = re.compile(
    r"\x1b(?:\[[0-?]*[ -/]*[@-~]|\][^\x07\x1b]*(?:\x07|\x1b\\)"
    r"|[PX^_][\s\S]*?\x1b\\|[@-_])"
)
SGR = re.compile(r"(\x1b\[[0-9;:]*m)")


def styled_lines(text):
    """Keep only SGR styling; record inherited styles before cropping rows."""
    text = ANSI_ESCAPE.sub(
        lambda match: match[0] if SGR.fullmatch(match[0]) else "", text
    )
    lines = []
    state = ""
    for line in text.splitlines():
        tokens = SGR.split(line)
        lines.append((state, tokens))
        for token in tokens:
            if SGR.fullmatch(token):
                # Only leading zero is a reset; RGB components may also be zero.
                if token in ("\x1b[m", "\x1b[0m") or token.startswith("\x1b[0;"):
                    state = token
                else:
                    state += token
    while lines and not "".join(
        token for token in lines[-1][1] if not SGR.fullmatch(token)
    ).strip():
        lines.pop()
    return lines


def cell_width(char):
    if unicodedata.combining(char):
        return 0
    return 2 if unicodedata.east_asian_width(char) in {"W", "F"} else 1


def clipped(text, columns):
    """Clip by terminal cells rather than codepoints; drop control characters."""
    result = []
    used = 0
    for char in str(text).expandtabs(4):
        if unicodedata.category(char).startswith("C"):
            continue
        width = cell_width(char)
        if used + width > columns:
            break
        if width or result:
            result.append(char)
        used += width
    return "".join(result)


def colored_line(line, columns):
    """Clip text by cells, retaining source RGB/indexed colors and SGR resets."""
    inherited, tokens = line
    output = ["\x1b[0m", inherited]
    remaining = columns
    for token in tokens:
        if SGR.fullmatch(token):
            output.append(token)
        elif remaining:
            plain = "".join(char for char in token.expandtabs(4)
                            if not unicodedata.category(char).startswith("C"))
            text = clipped(plain, remaining)
            output.append(text)
            remaining -= sum(cell_width(char) for char in text)
            if len(text) < len(plain):
                break
    output.extend((" " * remaining, "\x1b[0m"))
    return "".join(output)


def put(window, y, x, text, style=0, width=None):
    height, columns = window.getmaxyx()
    if not (0 <= y < height and 0 <= x < columns):
        return
    limit = columns - x if width is None else min(width, columns - x)
    if limit <= 0:
        return
    try:
        window.addstr(y, x, clipped(text, limit), style)
    except curses.error:
        # Writing the final terminal cell can succeed and still raise an error.
        pass


class Herdr:
    def __init__(self):
        self.binary = os.environ.get("HERDR_BIN_PATH") or shutil.which("herdr")
        if not self.binary:
            raise RuntimeError("herdr is not on PATH")

    def call(self, *args):
        result = subprocess.run(
            [self.binary, *args], stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            encoding="utf-8", errors="replace", timeout=COMMAND_TIMEOUT,
        )
        if result.returncode:
            detail = result.stderr.strip() or result.stdout.strip()
            raise RuntimeError(detail or "Herdr command failed")
        return result.stdout

    def snapshot(self):
        response = json.loads(self.call("api", "snapshot"))
        if response.get("error"):
            raise RuntimeError(response["error"].get("message", "Snapshot failed"))
        return response["result"]["snapshot"]

    def read(self, pane_id):
        text = self.call("pane", "read", pane_id, "--source", "visible",
                         "--format", "ansi", "--raw")
        return styled_lines(text)

    def focus(self, pane_id):
        response = json.loads(self.call("agent", "focus", pane_id))
        if response.get("error"):
            raise RuntimeError(response["error"].get("message", "Focus failed"))


class Dashboard:
    def __init__(self, screen):
        self.screen = screen
        self.herdr = Herdr()
        self.pool = concurrent.futures.ThreadPoolExecutor(max_workers=5)
        self.snapshot_job = None
        self.next_refresh = 0
        self.panes = []
        self.selected = os.environ.get("HERDR_ACTIVE_PANE_ID")
        self.top_row = 0
        self.previews = {}
        self.read_jobs = {}
        self.loaded = False
        self.error = ""
        self.notice = ""
        self.notice_until = 0
        self.colors = {}
        self.preview_frames = {}
        self.last_layout = None

    def setup(self):
        try:
            curses.curs_set(0)
        except curses.error:
            pass
        curses.set_escdelay(25)
        self.screen.keypad(True)
        self.screen.timeout(50)
        if curses.has_colors():
            curses.start_color()
            try:
                curses.use_default_colors()
                background = -1
            except curses.error:
                background = curses.COLOR_BLACK
            for number, (name, color) in enumerate([
                ("working", curses.COLOR_CYAN),
                ("blocked", curses.COLOR_YELLOW),
                ("done", curses.COLOR_GREEN),
                ("idle", curses.COLOR_BLUE),
                ("selected", curses.COLOR_CYAN),
            ], 1):
                if number < curses.COLOR_PAIRS:
                    curses.init_pair(number, color, background)
                    self.colors[name] = curses.color_pair(number)

    def index(self):
        return next((i for i, pane in enumerate(self.panes)
                     if pane["pane_id"] == self.selected), 0)

    def update_panes(self, snapshot):
        old_index = self.index()
        workspaces = {w["workspace_id"]: w for w in snapshot["workspaces"]}
        tabs = {t["tab_id"]: t for t in snapshot["tabs"]}
        panes = []
        for pane in snapshot["panes"]:
            if pane.get("agent") not in AGENT_KINDS:
                continue
            pane = dict(pane)
            workspace = workspaces.get(pane["workspace_id"], {})
            tab = tabs.get(pane["tab_id"], {})
            pane["workspace_label"] = workspace.get("label") or pane["workspace_id"]
            pane["title"] = (pane.get("display_agent") or tab.get("label")
                             or pane.get("terminal_title_stripped") or pane["pane_id"])
            pane["sort_key"] = (workspace.get("number", 0), tab.get("number", 0),
                                pane["pane_id"])
            panes.append(pane)
        panes.sort(key=lambda pane: pane["sort_key"])
        live_ids = {pane["pane_id"] for pane in panes}
        if self.selected not in live_ids:
            focused = snapshot.get("focused_pane_id") if not self.loaded else None
            self.selected = focused if focused in live_ids else (
                panes[min(old_index, len(panes) - 1)]["pane_id"] if panes else None
            )
        self.panes = panes
        self.previews = {key: value for key, value in self.previews.items()
                         if key in live_ids}

    def refresh(self, now):
        if self.snapshot_job is not None and self.snapshot_job.done():
            try:
                self.update_panes(self.snapshot_job.result())
                self.loaded = True
                self.error = ""
            except Exception as error:
                self.error = f"Disconnected / stale: {error}"
            self.snapshot_job = None
        if self.snapshot_job is None and now >= self.next_refresh:
            self.snapshot_job = self.pool.submit(self.herdr.snapshot)
            self.next_refresh = now + REFRESH_SECONDS
        live_ids = {pane["pane_id"] for pane in self.panes}
        for pane_id, job in list(self.read_jobs.items()):
            if not job.done():
                continue
            del self.read_jobs[pane_id]
            if pane_id not in live_ids:
                continue
            previous = self.previews.get(pane_id, {})
            try:
                self.previews[pane_id] = {
                    "lines": job.result(), "error": "",
                    "next_read_at": now + PREVIEW_REFRESH_SECONDS,
                }
            except Exception as error:
                self.previews[pane_id] = {
                    "lines": previous.get("lines", []),
                    "error": f"Preview stale: {error}",
                    "next_read_at": now + REFRESH_SECONDS,
                }

    def geometry(self):
        height, width = self.screen.getmaxyx()
        available = max(1, height - 2)
        count = max(1, len(self.panes))
        columns = min(count, max(1, width // 50), math.ceil(math.sqrt(count)))
        total_rows = math.ceil(count / columns)
        rows = min(total_rows, max(1, available // 10))
        selected_row = self.index() // columns
        self.top_row = max(0, min(self.top_row, max(0, total_rows - rows)))
        if selected_row < self.top_row:
            self.top_row = selected_row
        elif selected_row >= self.top_row + rows:
            self.top_row = selected_row - rows + 1
        return height, width, available, columns, rows

    def draw(self, now):
        self.screen.erase()
        height, width, available, columns, rows = self.geometry()
        layout = (height, width, columns, rows, len(self.panes), self.top_row)
        if layout != self.last_layout:
            # Curses doesn't track the truecolor preview cells we paint below.
            self.screen.redrawwin()
            self.preview_frames.clear()
            self.last_layout = layout
        if height < 8 or width < 24:
            put(self.screen, 0, 0, "Enlarge terminal (24 x 8). Esc: close")
            self.screen.refresh()
            return columns, rows
        count = len(self.panes)
        put(self.screen, 0, 0, f" Agents: {count} | live terminal previews", curses.A_BOLD)
        start = self.top_row * columns
        end = min(count, start + rows * columns)
        frames = {}
        changed_frames = []
        for index in range(start, end):
            pane = self.panes[index]
            pane_id = pane["pane_id"]
            row, column = divmod(index - start, columns)
            y = 1 + row * available // rows
            x = column * width // columns
            tile_height = (row + 1) * available // rows - row * available // rows
            tile_width = (column + 1) * width // columns - x
            tile = self.screen.derwin(tile_height, tile_width, y, x)
            status = pane.get("agent_status") or "unknown"
            selected = pane_id == self.selected
            border = (self.colors.get("selected", 0) | curses.A_BOLD
                      if selected else curses.A_DIM)
            tile.attrset(border)
            if selected:
                put(tile, 0, 0, "╔" + "═" * (tile_width - 2) + "╗", border)
                put(tile, tile_height - 1, 0,
                    "╚" + "═" * (tile_width - 2) + "╝", border)
                for edge_row in range(1, tile_height - 1):
                    put(tile, edge_row, 0, "║", border)
                    put(tile, edge_row, tile_width - 1, "║", border)
            else:
                tile.box()
            tile.attrset(0)
            put(tile, 0, 2, f" {'▶ ' if selected else ''}{pane['title']} ",
                border, tile_width - 4)
            heading_style = self.colors.get(status, 0)
            if selected:
                heading_style = border | curses.A_REVERSE
                put(tile, 1, 1, " " * (tile_width - 2), heading_style,
                    tile_width - 2)
            put(tile, 1, 2, f"{pane['workspace_label']} | {pane['agent']} | {status}",
                heading_style, tile_width - 4)
            preview = self.previews.get(pane_id, {})
            lines = preview.get("lines", [])
            message = preview.get("error", "")
            content_rows = tile_height - 3 - bool(message)
            visible_lines = lines[-content_rows:] if content_rows > 0 else []
            if not lines:
                label = "Reading screen..." if not preview else "(empty screen)"
                visible_lines = [("\x1b[2m", [label])]
            frame = []
            for offset in range(max(0, content_rows)):
                line = visible_lines[offset] if offset < len(visible_lines) else ("", [])
                frame.append(f"\x1b[{y + 3 + offset};{x + 3}H")
                frame.append(colored_line(line, tile_width - 4))
            frame = "".join(frame)
            rectangle = (y, x, tile_height, tile_width)
            frames[rectangle] = frame
            if self.preview_frames.get(rectangle) != frame:
                changed_frames.append(frame)
            if message:
                put(tile, tile_height - 2, 2, message, curses.A_DIM, tile_width - 4)
            put(tile, tile_height - 1, 2, f" {pane_id} ", border, tile_width - 4)
            if (not self.error and pane_id not in self.read_jobs
                    and now >= preview.get("next_read_at", 0)):
                # Herdr's revision can omit timer/spinner-only screen changes.
                self.read_jobs[pane_id] = self.pool.submit(self.herdr.read, pane_id)
        if not count:
            message = "No Codex or Claude agents in this Herdr session." if self.loaded else "Connecting to Herdr..."
            put(self.screen, 2, 2, message, curses.A_DIM)
        footer = self.error or (self.notice if now < self.notice_until else "")
        if not footer:
            footer = " hjkl/arrows: select | Enter: open | Esc/q: close"
            if count > end - start:
                footer = f" {start + 1}-{end}/{count} |" + footer
                if width >= len(footer) + 12:
                    footer += " | PgUp/PgDn"
        put(self.screen, height - 1, 0, footer,
            self.colors.get("blocked", 0) if self.error else curses.A_DIM)
        self.screen.refresh()
        if changed_frames:
            # DECSC/DECRC restore the cursor and SGR state expected by curses.
            # Only whitelisted SGR codes reach here; source cursor/OSC commands
            # cannot move outside a tile or change the outer terminal.
            sys.stdout.write("\x1b7" + "".join(changed_frames) + "\x1b8")
            sys.stdout.flush()
        self.preview_frames = frames
        return columns, rows

    def handle_key(self, key, columns, rows):
        if key in ("\x1b", "q", "Q"):
            return False
        if key in ("\n", "\r", curses.KEY_ENTER) and self.panes:
            try:
                self.herdr.focus(self.selected)
                return False
            except Exception as error:
                self.notice = f"Cannot open agent: {error}"
                self.notice_until = time.monotonic() + 4
                self.next_refresh = 0
        movements = {
            curses.KEY_LEFT: -1, "h": -1, curses.KEY_RIGHT: 1, "l": 1,
            curses.KEY_UP: -columns, "k": -columns,
            curses.KEY_DOWN: columns, "j": columns,
            curses.KEY_PPAGE: -columns * rows, curses.KEY_NPAGE: columns * rows,
            curses.KEY_HOME: -len(self.panes), curses.KEY_END: len(self.panes),
        }
        if key in movements and self.panes:
            index = max(0, min(len(self.panes) - 1, self.index() + movements[key]))
            self.selected = self.panes[index]["pane_id"]
        return True

    def run(self):
        try:
            self.setup()
            while True:
                now = time.monotonic()
                self.refresh(now)
                columns, rows = self.draw(now)
                try:
                    key = self.screen.get_wch()
                except curses.error:
                    continue
                if not self.handle_key(key, columns, rows):
                    break
        finally:
            self.pool.shutdown(wait=True, cancel_futures=True)


def main():
    locale.setlocale(locale.LC_ALL, "")
    try:
        curses.wrapper(lambda screen: Dashboard(screen).run())
    except KeyboardInterrupt:
        pass
    except (RuntimeError, OSError, curses.error) as error:
        raise SystemExit(f"Herdr dashboard: {error}") from error


if __name__ == "__main__":
    main()

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
import socket
import sys
import time
import unicodedata


REFRESH_SECONDS = 1.0
PREVIEW_REFRESH_SECONDS = 0.2
COMMAND_TIMEOUT = 2.0
AGENT_KINDS = {"codex", "claude"}
# (urgency, badge, colour key); urgency < 2 needs attention.
STATUSES = {
    "blocked": (0, "● NEEDS INPUT", "blocked"), "done": (1, "✓ DONE", "done"),
    "idle": (2, "○ idle", "idle"), "working": (3, "◐ working", "working"),
    "unknown": (4, "? unknown", None),
}
HEADER_COUNTS = (("blocked", "● {} needs input"), ("done", "✓ {} done"),
                 ("working", "◐ {} working"), ("idle", "○ {} idle"))
ANSI_ESCAPE = re.compile(
    r"\x1b(?:\[[0-?]*[ -/]*[@-~]|\][^\x07\x1b]*(?:\x07|\x1b\\)"
    r"|[PX^_][\s\S]*?\x1b\\|[@-_])"
)
SGR = re.compile(r"(\x1b\[[0-9;:]*m)")


def plain_text(line):
    return "".join(token for token in line[1] if not SGR.fullmatch(token))


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
    while lines and not plain_text(lines[-1]).strip():
        lines.pop()
    return lines


def is_rule(text):
    # Claude right-aligns the running task's title inside the upper rule.
    text = text.strip()
    return text.startswith("─" * 10) and text.endswith("─")


def without_input_box(lines):
    """Drop Claude's prompt box and everything under it, keeping the spinner line."""
    texts = [plain_text(line) for line in lines]
    # Claude lists background tasks below its status lines, so look past the box.
    for upper in range(max(0, len(lines) - 16), len(lines) - 2):
        if (is_rule(texts[upper]) and texts[upper + 1].lstrip().startswith("❯")
                and any(map(is_rule, texts[upper + 2:upper + 5]))):
            lines = lines[:upper]
            while lines and not plain_text(lines[-1]).strip():
                lines.pop()
            return lines
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
        self.socket_path = os.environ.get("HERDR_SOCKET_PATH")
        if not self.socket_path:
            raise RuntimeError("HERDR_SOCKET_PATH is not set")

    def call(self, method, **params):
        # The server answers one newline-terminated request per connection.
        request = json.dumps({"id": "1", "method": method, "params": params})
        with socket.socket(socket.AF_UNIX) as connection:
            connection.settimeout(COMMAND_TIMEOUT)
            connection.connect(self.socket_path)
            connection.sendall(request.encode() + b"\n")
            line = connection.makefile("rb").readline()
        if not line:
            raise RuntimeError("Herdr closed the connection")
        response = json.loads(line)
        if response.get("error"):
            raise RuntimeError(response["error"].get("message", f"{method} failed"))
        return response["result"]

    def snapshot(self):
        return self.call("session.snapshot")["snapshot"]

    def read(self, pane_id):
        result = self.call("pane.read", pane_id=pane_id, source="visible",
                           format="ansi", strip_ansi=False)
        return styled_lines(result["read"]["text"])

    def focus(self, pane_id):
        self.call("agent.focus", target=pane_id)


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
            status = pane.get("agent_status")
            pane["status"] = status if status in STATUSES else "unknown"
            pane["title"] = (pane.get("label") or pane.get("terminal_title_stripped")
                             or tab.get("label") or pane.get("display_agent")
                             or pane["pane_id"])
            pane["sort_key"] = (STATUSES[pane["status"]][0], workspace.get("number", 0),
                                tab.get("number", 0), pane["pane_id"])
            panes.append(pane)
        panes.sort(key=lambda pane: pane["sort_key"])
        live_ids = {pane["pane_id"] for pane in panes}
        if not self.loaded and panes and STATUSES[panes[0]["status"]][0] < 2:
            self.selected = panes[0]["pane_id"]
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
        counts = {}
        for pane in self.panes:
            counts[pane["status"]] = counts.get(pane["status"], 0) + 1
        segments = [(f" {text.format(counts[status])}  ",
                     self.colors.get(status, 0) | curses.A_BOLD)
                    for status, text in HEADER_COUNTS if counts.get(status)]
        header_x = 0
        for text, style in segments or [(f" Agents: {count}", curses.A_BOLD)]:
            put(self.screen, 0, header_x, text, style)
            header_x += sum(map(cell_width, text))
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
            status = pane["status"]
            urgency, badge, color = STATUSES[status]
            attention = urgency < 2
            selected = pane_id == self.selected
            border = self.colors.get(color, curses.A_DIM)
            if attention or selected:
                border |= curses.A_BOLD
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
            room = tile_width - 4
            left = clipped(f" {'▶ ' if selected else ''}{badge}  {pane['title']} ", room)
            right = f" {pane['agent']} · {pane['workspace_label']} "
            left_width = sum(map(cell_width, left))
            right_width = sum(map(cell_width, right))
            put(tile, 0, 2, left, border, room)
            if left_width + right_width + 1 <= room:
                put(tile, 0, tile_width - 2 - right_width, right, border)
            preview = self.previews.get(pane_id, {})
            lines = preview.get("lines", [])
            # A blocked pane's prompt box is the permission dialog the user must see.
            if status != "blocked":
                lines = without_input_box(lines)
            message = preview.get("error", "")
            content_rows = tile_height - 2 - bool(message)
            visible_lines = lines[-content_rows:] if content_rows > 0 else []
            if not lines:
                label = "Reading screen..." if not preview else "(empty screen)"
                visible_lines = [("\x1b[2m", [label])]
            frame = []
            for offset in range(max(0, content_rows)):
                line = visible_lines[offset] if offset < len(visible_lines) else ("", [])
                frame.append(f"\x1b[{y + 2 + offset};{x + 3}H")
                frame.append(colored_line(line, tile_width - 4))
            frame = "".join(frame)
            rectangle = (y, x, tile_height, tile_width)
            frames[rectangle] = frame
            if self.preview_frames.get(rectangle) != frame:
                changed_frames.append(frame)
            if message:
                put(tile, tile_height - 2, 2, message, curses.A_DIM, tile_width - 4)
            if (not self.error and pane_id not in self.read_jobs
                    and now >= preview.get("next_read_at", 0)):
                # Herdr's revision can omit timer/spinner-only screen changes.
                self.read_jobs[pane_id] = self.pool.submit(self.herdr.read, pane_id)
        if not count:
            message = "No Codex or Claude agents in this Herdr session." if self.loaded else "Connecting to Herdr..."
            put(self.screen, 2, 2, message, curses.A_DIM)
        footer = self.error or (self.notice if now < self.notice_until else "")
        if not footer:
            footer = " Enter open · hjkl move · Esc close"
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

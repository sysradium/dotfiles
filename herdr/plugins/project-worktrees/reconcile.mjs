import { basename, dirname } from "node:path";
import { realpathSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { pathToFileURL } from "node:url";

const METADATA_SOURCE = "alex.project-worktrees";

function idNumber(id) {
  const match = String(id).match(/(\d+)$/);
  return match ? Number(match[1]) : Number.MAX_SAFE_INTEGER;
}

function byNumberThenId(a, b) {
  return (a.number ?? idNumber(a.tab_id ?? a.pane_id)) -
    (b.number ?? idNumber(b.tab_id ?? b.pane_id)) ||
    String(a.tab_id ?? a.pane_id).localeCompare(String(b.tab_id ?? b.pane_id));
}

function canonicalPath(path) {
  try {
    return realpathSync.native(path);
  } catch {
    return path;
  }
}

function run(command, args) {
  const result = spawnSync(command, args, {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"],
  });

  if (result.status !== 0) {
    return null;
  }

  return result.stdout.trim();
}

export function resolveGitContext(cwd) {
  if (!cwd) return null;

  const topLevel = run("git", ["-C", cwd, "rev-parse", "--show-toplevel"]);
  const gitDir = run("git", ["-C", cwd, "rev-parse", "--absolute-git-dir"]);
  const commonDir = run("git", [
    "-C",
    cwd,
    "rev-parse",
    "--path-format=absolute",
    "--git-common-dir",
  ]);

  if (!topLevel || !gitDir || !commonDir) return null;

  const canonicalGitDir = canonicalPath(gitDir);
  const canonicalCommonDir = canonicalPath(commonDir);
  if (canonicalGitDir === canonicalCommonDir) return null;

  const branch = run("git", [
    "-C",
    cwd,
    "symbolic-ref",
    "--quiet",
    "--short",
    "HEAD",
  ]);
  const commonBase = basename(canonicalCommonDir);
  const project = commonBase === ".git"
    ? basename(dirname(canonicalCommonDir))
    : commonBase.replace(/\.git$/, "");

  return {
    branch: branch || basename(topLevel),
    commonDir: canonicalCommonDir,
    project,
    topLevel: canonicalPath(topLevel),
  };
}

function paneCwd(pane) {
  return pane.foreground_cwd || pane.cwd;
}

function generatedWorkspaceLabel(label, context) {
  return label === basename(context.topLevel) || label === context.branch;
}

function generatedTabLabel(label, context) {
  return /^\d+$/.test(label) || label === basename(context.topLevel);
}

export function buildActions(snapshot, gitContextForCwd = resolveGitContext) {
  const actions = [];
  const contexts = new Map();
  const contextForPane = (pane) => {
    const cwd = paneCwd(pane);
    if (!contexts.has(cwd)) contexts.set(cwd, gitContextForCwd(cwd));
    return contexts.get(cwd);
  };

  for (const workspace of snapshot.workspaces ?? []) {
    const tabs = (snapshot.tabs ?? [])
      .filter((tab) => tab.workspace_id === workspace.workspace_id)
      .sort(byNumberThenId);
    const firstTab = tabs[0];
    if (!firstTab) continue;

    const firstTabPanes = (snapshot.panes ?? [])
      .filter((pane) => pane.tab_id === firstTab.tab_id)
      .sort(byNumberThenId);
    const anchorPane = firstTabPanes[0];
    const workspaceContext = anchorPane && contextForPane(anchorPane);

    // A Space is only project-owned when its original/lowest pane is itself in a
    // linked worktree. This prevents a linked-worktree split inside an unrelated
    // Space from renaming that Space.
    if (!workspaceContext) continue;

    if (
      workspace.label !== workspaceContext.project &&
      generatedWorkspaceLabel(workspace.label, workspaceContext)
    ) {
      actions.push([
        "workspace",
        "rename",
        workspace.workspace_id,
        workspaceContext.project,
      ]);
    }

    for (const tab of tabs) {
      const tabPanes = (snapshot.panes ?? [])
        .filter((pane) => pane.tab_id === tab.tab_id)
        .sort(byNumberThenId);
      const tabContexts = tabPanes
        .map((pane) => contextForPane(pane))
        .filter((context) => context?.commonDir === workspaceContext.commonDir);
      const topLevels = new Set(tabContexts.map((context) => context.topLevel));

      // A tab spanning multiple worktrees is ambiguous and remains user-owned.
      if (topLevels.size !== 1) continue;
      const tabContext = tabContexts[0];

      if (
        tab.label !== tabContext.branch &&
        generatedTabLabel(tab.label, tabContext)
      ) {
        actions.push(["tab", "rename", tab.tab_id, tabContext.branch]);
      }

      for (const pane of tabPanes) {
        if (!pane.agent) continue;
        const paneContext = contextForPane(pane);
        if (
          !paneContext ||
          paneContext.commonDir !== workspaceContext.commonDir ||
          paneContext.topLevel !== tabContext.topLevel
        ) {
          continue;
        }

        actions.push([
          "pane",
          "report-metadata",
          pane.pane_id,
          "--source",
          METADATA_SOURCE,
          "--agent",
          pane.agent,
          "--display-agent",
          paneContext.branch,
        ]);
      }
    }
  }

  return actions;
}

function herdr(args) {
  const binary = process.env.HERDR_BIN_PATH || "herdr";
  const result = spawnSync(binary, args, {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"],
  });

  if (result.status !== 0) {
    const detail = result.stderr.trim() || result.stdout.trim();
    throw new Error(`${binary} ${args.join(" ")} failed: ${detail}`);
  }

  return result.stdout.trim();
}

export function main() {
  const response = JSON.parse(herdr(["api", "snapshot"]));
  for (const args of buildActions(response.result.snapshot)) {
    herdr(args);
  }
}

const invokedPath = process.argv[1] && pathToFileURL(process.argv[1]).href;
if (invokedPath === import.meta.url) {
  try {
    main();
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  }
}


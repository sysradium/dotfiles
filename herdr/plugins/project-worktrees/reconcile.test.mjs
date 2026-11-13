import assert from "node:assert/strict";
import test from "node:test";

import { buildActions } from "./reconcile.mjs";

function linked(project, branch, topLevel, commonDir) {
  return { project, branch, topLevel, commonDir };
}

test("renames a linked-worktree Space and reports the exact branch as the agent name", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w1", label: "main" }],
    tabs: [{ workspace_id: "w1", tab_id: "w1:t1", label: "1", number: 1 }],
    panes: [{
      workspace_id: "w1",
      tab_id: "w1:t1",
      pane_id: "w1:p1",
      cwd: "/projects/example-project/main",
      agent: "codex",
    }],
  };
  const context = linked("example-project", "main", "/projects/example-project/main", "/projects/example-project/.git");

  assert.deepEqual(buildActions(snapshot, () => context), [
    ["workspace", "rename", "w1", "example-project"],
    ["tab", "rename", "w1:t1", "main"],
    [
      "pane",
      "report-metadata",
      "w1:p1",
      "--source",
      "sysradium.project-worktrees",
      "--agent",
      "codex",
      "--display-agent",
      "main",
    ],
  ]);
});

test("preserves slash-containing branch names", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w1", label: "example-project" }],
    tabs: [{ workspace_id: "w1", tab_id: "w1:t2", label: "feature-add-search", number: 2 }],
    panes: [{
      workspace_id: "w1",
      tab_id: "w1:t2",
      pane_id: "w1:p2",
      cwd: "/projects/example-project/feature-add-search",
      agent: "claude",
    }],
  };
  const context = linked(
    "example-project",
    "feature/add-search",
    "/projects/example-project/feature-add-search",
    "/projects/example-project/.git",
  );

  assert.deepEqual(buildActions(snapshot, () => context), [
    ["tab", "rename", "w1:t2", "feature/add-search"],
    [
      "pane",
      "report-metadata",
      "w1:p2",
      "--source",
      "sysradium.project-worktrees",
      "--agent",
      "claude",
      "--display-agent",
      "feature/add-search",
    ],
  ]);
});

test("does not rename an ordinary or mixed-project Space", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w4", label: "tools" }],
    tabs: [{ workspace_id: "w4", tab_id: "w4:t1", label: "1", number: 1 }],
    panes: [
      {
        workspace_id: "w4",
        tab_id: "w4:t1",
        pane_id: "w4:p1",
        cwd: "/projects/tools",
        agent: "codex",
      },
      {
        workspace_id: "w4",
        tab_id: "w4:t1",
        pane_id: "w4:p3",
        cwd: "/projects/example-project/main",
      },
    ],
  };
  const context = linked("example-project", "main", "/projects/example-project/main", "/projects/example-project/.git");
  const resolve = (cwd) => cwd === "/projects/example-project/main" ? context : null;

  assert.deepEqual(buildActions(snapshot, resolve), []);
});

test("manual Space and tab labels win", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w1", label: "custom-space" }],
    tabs: [{ workspace_id: "w1", tab_id: "w1:t1", label: "review", number: 1 }],
    panes: [{
      workspace_id: "w1",
      tab_id: "w1:t1",
      pane_id: "w1:p1",
      cwd: "/projects/example-project/feature-branch",
      agent: "codex",
    }],
  };
  const context = linked("example-project", "feature-branch", "/projects/example-project/feature-branch", "/projects/example-project/.git");

  assert.deepEqual(buildActions(snapshot, () => context), [[
    "pane",
    "report-metadata",
    "w1:p1",
    "--source",
    "sysradium.project-worktrees",
    "--agent",
    "codex",
    "--display-agent",
    "feature-branch",
  ]]);
});


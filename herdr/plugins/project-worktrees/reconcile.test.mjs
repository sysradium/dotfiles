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
      cwd: "/dev/cowork/main",
      agent: "codex",
    }],
  };
  const context = linked("cowork", "main", "/dev/cowork/main", "/dev/cowork/.git");

  assert.deepEqual(buildActions(snapshot, () => context), [
    ["workspace", "rename", "w1", "cowork"],
    ["tab", "rename", "w1:t1", "main"],
    [
      "pane",
      "report-metadata",
      "w1:p1",
      "--source",
      "alex.project-worktrees",
      "--agent",
      "codex",
      "--display-agent",
      "main",
    ],
  ]);
});

test("preserves slash-containing branch names", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w1", label: "cowork" }],
    tabs: [{ workspace_id: "w1", tab_id: "w1:t2", label: "feature-sop-preview", number: 2 }],
    panes: [{
      workspace_id: "w1",
      tab_id: "w1:t2",
      pane_id: "w1:p2",
      cwd: "/dev/cowork/feature-sop-preview",
      agent: "claude",
    }],
  };
  const context = linked(
    "cowork",
    "feature/sop-preview",
    "/dev/cowork/feature-sop-preview",
    "/dev/cowork/.git",
  );

  assert.deepEqual(buildActions(snapshot, () => context), [
    ["tab", "rename", "w1:t2", "feature/sop-preview"],
    [
      "pane",
      "report-metadata",
      "w1:p2",
      "--source",
      "alex.project-worktrees",
      "--agent",
      "claude",
      "--display-agent",
      "feature/sop-preview",
    ],
  ]);
});

test("does not rename an ordinary or mixed-project Space", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w4", label: "dotfiles" }],
    tabs: [{ workspace_id: "w4", tab_id: "w4:t1", label: "1", number: 1 }],
    panes: [
      {
        workspace_id: "w4",
        tab_id: "w4:t1",
        pane_id: "w4:p1",
        cwd: "/dev/dotfiles",
        agent: "codex",
      },
      {
        workspace_id: "w4",
        tab_id: "w4:t1",
        pane_id: "w4:p3",
        cwd: "/dev/cowork/main",
      },
    ],
  };
  const context = linked("cowork", "main", "/dev/cowork/main", "/dev/cowork/.git");
  const resolve = (cwd) => cwd === "/dev/cowork/main" ? context : null;

  assert.deepEqual(buildActions(snapshot, resolve), []);
});

test("manual Space and tab labels win", () => {
  const snapshot = {
    workspaces: [{ workspace_id: "w1", label: "payments" }],
    tabs: [{ workspace_id: "w1", tab_id: "w1:t1", label: "review", number: 1 }],
    panes: [{
      workspace_id: "w1",
      tab_id: "w1:t1",
      pane_id: "w1:p1",
      cwd: "/dev/cowork/ENG-6610",
      agent: "codex",
    }],
  };
  const context = linked("cowork", "ENG-6610", "/dev/cowork/ENG-6610", "/dev/cowork/.git");

  assert.deepEqual(buildActions(snapshot, () => context), [[
    "pane",
    "report-metadata",
    "w1:p1",
    "--source",
    "alex.project-worktrees",
    "--agent",
    "codex",
    "--display-agent",
    "ENG-6610",
  ]]);
});


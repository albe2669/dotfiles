---
name: implement-with-subagents
description: Orchestrator-implement-review loop for multi-file or multi-step changes. The main agent plans, dispatches `task` subagents to implement in parallel, dispatches a `reviewer` subagent to gate it, triages feedback — forward fixes to the implementer or escalate a wrong task to the user — loops until the reviewer approves, then runs final checks.
---

# Implement with subagents

The orchestrator runs a loop that **converges** when the reviewer approves. The orchestrator plans, dispatches, and triages; the implementers write the change. The `task` tool is built into omp — each dispatch is one or more `tasks[]` entries.

## State file — surviving compaction

The skill's *process* survives compaction (model-invoked, re-injected every turn). What compaction destroys is *loop state*: the plan, the review verdict and findings, which iteration, which slices are done. Subagent handles expire minutes after settlement, so they are not the durable record.

At the start of the run, create a state file — `local://implement-loop.md` — and append to it at the end of every phase. Read it at the start of every phase to resume after compaction. One section per phase, newest at the bottom:

```
## Task
<original task verbatim>

## Plan
<slices, acceptance criteria>

## Iteration 1
- implementer: <files changed, summary>
- reviewer: <verdict, findings>
- triage: <routing decisions>

## Iteration 2
...
```

Never commit this file.

**Done when** the state file holds the original task, the plan, and a record of every iteration's implement, review, and triage.

## Phase 1 — Plan

Read the task. When the files or symbols the change touches are unknown, dispatch **scout** subagents (`agent: "scout"`) to map them before planning — name the area to investigate in each prompt, not a broad "explore the codebase". Scouts map only; the implementers edit.

Write the plan. Define the **what**, not the how — the change and its boundaries, the acceptance criteria the reviewer checks. Do not enumerate every symbol to touch; the implementer decides how. Do decompose the plan into **slices** that can run in parallel when the work has independent parts; order slices that depend on each other.

Append the plan to the state file.

**Done when** the plan names the change, its slice decomposition, and acceptance criteria the reviewer can check — without prescribing the implementation.

## Phase 2 — Implement

Dispatch implementer subagents. Use the default worker (omit `agent`). One `tasks[]` batch dispatches parallel slices together — each item a self-contained slice with its own target files and acceptance criteria. Sequential slices wait: dispatch them only when the slice they depend on has returned.

Every implementer prompt carries the original task, the slice it owns, the acceptance criteria, and instruction to skip validation (lint, build, tests) — the reviewer and orchestrator run those.

### Isolation for separate work

When a slice or a series of slices is entirely separate — different files, no shared state with the others — isolate it so parallel work does not collide:

- **Slices of one change** — `task` with `isolated: true` and `merge`. The subagent works in a throwaway worktree; the orchestrator controls the merge. Light, built-in, ephemeral. Use this for parallel slices of a single change.
- **Large, entirely-separate efforts** — a separate omp instance in its own worktree, merged via git later. When running inside Herdr (`HERDR_ENV=1`), split a pane and start an agent: `herdr pane split --current --direction right --cwd "$PWD" --no-focus`, then `herdr agent start <name> --kind omp --pane <pane-id>`, then `herdr agent prompt <name> "<task>" --wait`. Merge the worktree branch back via git when it finishes. Use this when the effort is large enough to warrant a persistent, independent instance the orchestrator checks on later rather than a subagent that returns.

Append each implementer's result (files changed, summary) to the state file under the current iteration.

**Done when** every dispatched slice has returned and its result is recorded in the state file.

## Phase 3 — Review

Dispatch one `reviewer` subagent (`agent: "reviewer"`) with the original task, the plan, and every implementer's summary plus the files it changed. Ask for a verdict — **approved** or **needs changes** — with each finding as a specific, actionable item: file, what is wrong, what to do. An `outputSchema` with `verdict` and `findings[]` makes the result parseable.

Append the verdict and findings to the state file.

**Done when** the reviewer returns a verdict with every finding actionable, recorded in the state file.

## Phase 4 — Triage

For every review finding, route it one way:

- **Valid implementation issue** — the implementation is at fault (bug, broken contract, missed acceptance criterion, violation of a documented repo convention, incomplete against the plan) → forward to the implementer: re-dispatch a `task` with the finding and the file it names. Return to Phase 2.
- **Red** — the task, not the implementation, is at fault (the spec contradicts itself or a real constraint, the ask is unsatisfiable as written, a requirement the user must decide is missing) → stop the loop. A spec problem goes to the user, with what is wrong and the decision needed.

When unsure which: a wrong line is a fix; a wrong premise is red.

Append every routing decision to the state file.

**Done when** every finding is routed to the implementer or escalated and recorded; none dropped.

## Phase 5 — Converge

Repeat Phases 2–4 until the reviewer returns **approved**. The loop converges on reviewer sign-off, not on the implementer claiming done.

**Done when** the reviewer verdict is approved, recorded in the state file.

## Phase 6 — Final checks

The orchestrator runs the project's verification — tests, lint, build, and any check named in `AGENTS.md` / `CLAUDE.md` or the repo's make or just file. These were deliberately skipped inside the loop; run them now on the converged change.

**Done when** every check passes clean.

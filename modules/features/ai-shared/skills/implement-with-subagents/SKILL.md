---
name: implement-with-subagents
description: The workflowz implement-review loop. The main agent plans, dispatches `agent()` subagents to implement in parallel, dispatches a `reviewer` subagent to gate it, triages feedback — forward fixes to the implementer or escalate a wrong task to the user — loops until the reviewer approves, then runs final checks.
---

# Implement with subagents

The **workflowz** notice injects the `eval` contract — `agent()`, `parallel()`, `pipeline()`, `completion()` — that this loop runs in. This skill adds the one thing the notice does not: a plan → implement → review → triage → converge loop with compaction-durable state and final checks. The notice is the source of truth for the helpers; this skill is the source of truth for the loop.

The orchestrator plans, dispatches, and triages; the implementers write the change. The loop **converges** on reviewer sign-off, not on the implementer claiming done. All execution is synchronous within `eval` — `agent()` blocks and returns the subagent's output; chain `eval` calls across turns for phases.

## State file — surviving compaction

The workflowz process survives compaction (model-invoked, re-injected every turn). What compaction destroys is loop state: the plan, the review verdict and findings, which iteration, which slices are done. Subagent returns are not durable across compaction.

Create `local://implement-loop.md` at the start of the run. Append to it at the end of every phase; read it at the start of every phase to resume. Newest at the bottom:

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

**Done when** the state file holds the original task, the plan, and a record of every iteration's implement, review, and triage.

## Phase 1 — Plan

Read the task. When the files or symbols the change touches are unknown, scout first — `agent("…", agent="scout")` to map each unknown area, not a broad "explore the codebase". Scouts map only; implementers edit.

Write the plan. Define the **what**, not the how — the change and its boundaries, the acceptance criteria the reviewer checks. Do not enumerate every symbol to touch; the implementer decides how. Do decompose the plan into **slices** that can run in parallel when the work has independent parts; order slices that depend on each other.

Append the plan to the state file.

**Done when** the plan names the change, its slice decomposition, and acceptance criteria the reviewer can check — without prescribing the implementation.

## Phase 2 — Implement

Dispatch implementers with `agent()` — omit `agent` for the default worker. Parallel slices go in one `parallel([…])` call; each thunk a self-contained slice with its own target files and acceptance criteria. Sequential slices wait: dispatch only when the slice they depend on has returned.

Every implementer prompt carries the original task, the slice it owns, the acceptance criteria, and instruction to skip validation (lint, build, tests) — the reviewer and orchestrator run those.

### Isolation for separate work

When a slice is entirely separate — different files, no shared state with the others — isolate it so parallel work does not collide:

- **Slices of one change** — `agent(prompt, isolated=true, merge=true)`. The subagent works in a throwaway worktree; the orchestrator controls the merge. Use this for parallel slices of a single change.
- **Large, entirely-separate efforts** — a separate omp instance in its own worktree, merged via git later. When inside Herdr (`HERDR_ENV=1`): `herdr pane split --current --direction right --cwd "$PWD" --no-focus`, then `herdr agent start <name> --kind omp --pane <pane-id>`, then `herdr agent prompt <name> "<task>" --wait`. Merge the worktree branch via git when it finishes. Use this when the effort is large enough to warrant a persistent instance checked on later rather than a subagent that returns. For fire-and-forget delegation where the orchestrator should not block, use the `task` tool instead of `eval`'s `agent()`.

Append each implementer's result (files changed, summary) to the state file under the current iteration.

**Done when** every dispatched slice has returned and its result is recorded in the state file.

## Phase 3 — Review

Dispatch one reviewer with `agent("…", agent="reviewer", schema=REVIEW_SCHEMA)` — give it the original task, the plan, and every implementer's summary plus the files it changed. The schema forces a parseable verdict:

```js
const REVIEW_SCHEMA = {
  type: "object",
  properties: {
    verdict: { type: "string", enum: ["approved", "needs changes"] },
    findings: {
      type: "array",
      items: {
        type: "object",
        properties: {
          file: { type: "string" },
          issue: { type: "string" },
          fix: { type: "string" },
        },
        required: ["file", "issue", "fix"],
      },
    },
  },
  required: ["verdict", "findings"],
};
```

Each finding is a specific, actionable item: file, what is wrong, what to do.

Append the verdict and findings to the state file.

**Done when** the reviewer returns a verdict with every finding actionable, recorded in the state file.

## Phase 4 — Triage

For every review finding, route it one way:

- **Valid implementation issue** — the implementation is at fault (bug, broken contract, missed acceptance criterion, violation of a documented repo convention, incomplete against the plan) → forward to the implementer: re-dispatch `agent()` with the finding and the file it names. Return to Phase 2.
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

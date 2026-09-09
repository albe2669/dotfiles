---
name: implement-with-subagents
description: The workflowz implement-review loop. The main agent plans, dispatches `agent()` subagents to implement in parallel, dispatches a `reviewer` subagent to gate it, triages feedback — forward fixes to the implementer or escalate a wrong task to the user — loops until the reviewer approves, then runs final checks.
---

# Implement with subagents

The **workflowz** notice injects the `eval` contract — `agent()`, `wait()`, `completion()`, and (when available) `parallel()`/`pipeline()` — that this loop runs in. This skill adds the one thing the notice does not: a plan → implement → review → triage → converge loop with compaction-durable state and final checks. The notice is the source of truth for the helpers; this skill is the source of truth for the loop.

The orchestrator plans, dispatches, and triages; the implementers write the change. The loop **converges** on reviewer sign-off, not on the implementer claiming done.

## Runtime facts (verified)

- `agent(prompt, opts)` **spawns and returns immediately**; it does NOT block. In JS always `await agent(...)` — the resolved handle is `{ kind, id, agent, handle }` (`agent://<id>`). An un-awaited `agent()` call still spawns but hands back a useless empty object.
- `wait(handles, { raiseErrors })` is the barrier that blocks for results. In JS it takes ONE trailing options object — positional arguments like `wait(hs, null, false)` crash the cell. `raiseErrors: false` keeps a failed slice's error in its slot instead of throwing.
- `isolated: true` (throwaway worktree per subagent) requires `task.isolation.enabled`; it is often **false**. See the shared-tree fallback below.
- Chain phases as separate `eval` calls across turns; append to the state file before yielding so compaction cannot lose the loop.

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

Write the plan. Define the **what**, not the how — the change and its boundaries, the acceptance criteria the reviewer checks. Do not enumerate every symbol to touch; the implementer decides how. Do decompose the plan into **slices** that can run in parallel when the work has independent parts; order slices that depend on each other into waves (wave 1 = independent slices, wave 2 = slices that edit files a wave-1 slice owns).

Append the plan to the state file.

**Done when** the plan names the change, its slice decomposition, and acceptance criteria the reviewer can check — without prescribing the implementation.

## Phase 2 — Implement

Dispatch implementers with `await agent(prompt, { label })` — omit `agent` for the default worker. Each prompt is self-contained: the original task, the slice it owns (with its exact file list), the acceptance criteria, and instruction to skip validation (lint, build, tests) — the reviewer and orchestrator run those.

Parallel slices: dispatch every slice of a wave in one eval cell, then `await wait([a, b], { raiseErrors: false })` as the wave barrier. Sequential slices wait: dispatch only when the slice they depend on has returned and its result is recorded.

### Shared-tree fallback (when isolation is off)

`isolated: true` fails outright when `task.isolation.enabled` is false. In that case run the wave on the shared working tree with this protocol:

1. **Disjoint file ownership.** Each prompt names its exact files; slices must not share a file — including docs. One file touched by two slices = two waves, never one.
2. **One committer per wave.** At most one agent runs git (its own conventional commits, explicit `git add <paths>`, never `git add -A`). The other slices edit only and report their per-candidate file sets; the orchestrator stages and commits those after the wave returns. Two agents committing concurrently race on the git index.
3. **Docs belong to the orchestrator.** Every slice wants to update the same docs file — take docs out of all slice scopes and write them yourself (one docs commit, or folded into the slice commit you stage).
4. **Build gate between waves.** After merging a wave, run the project's type check/build before dispatching the next wave — cheap drift catch while the fix is still in one person's head.

### If the user is working in the same tree

Before dispatching, `git status --short`. Unexpected modified/untracked files are the USER's work — treat as ground truth, never commit, revert, or "fix" them. Block (`todo block`) any slice whose file list overlaps the user's dirty files and ask how to split the remaining work. Reviewers must review the committed range only (`git diff <base>..<head>`), so in-flight user edits stay out of the verdict.

Append each implementer's result (files changed, summary) to the state file under the current iteration.

**Done when** every dispatched slice has returned and its result is recorded in the state file.

## Phase 3 — Review

Dispatch one reviewer with `agent("…", agent="reviewer", schema=REVIEW_SCHEMA)`. Reviewers are strictly read-only. If the working tree is dirty with user work, scope the review to the committed range (`git diff <base>..<head>`) and say so in the prompt.

Give the reviewer the original task, the plan, and every implementer's summary plus the files it changed. The schema forces a parseable verdict:

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

Each finding is a specific, actionable item: file, what is wrong, what to do. Tell the reviewer to verify claims itself (grep, git show) — implementer summaries are claims, not evidence.

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

The orchestrator runs the project's verification — tests, lint, build, and any check named in `AGENTS.md` / `CLAUDE.md` or the repo's make or just file. These were deliberately skipped inside the loop; run them now on the converged change. A build gate ran between waves for type errors — the final checks re-run everything together on the converged tree.

**Done when** every check passes clean.

# Documentation Rules

Documentation owns durable project memory. It records decisions, user-visible
behavior, workflow state, public contracts, and handoff state.

## Write-Back Triggers

Update related docs in the same task when any of these change:

- Behavior
- Interfaces
- Workflows
- Acceptance criteria
- Public contracts
- Constraints or assumptions
- Usage or operational commands

Documentation write-back is part of implementation, not optional cleanup.

## Ownership

- Global `CLAUDE.md` or `AGENTS.md` owns concise baseline rules and rule links.
- Project `CLAUDE.md` or `AGENTS.md` owns project-specific workflow, commands,
  paths, and constraints.
- Project rule files own durable project-specific guidance.
- Spec owns requirements and acceptance criteria.
- Plan owns route, sequencing, dependencies, progress, and risks.
- Task owns execution scope, checklist, verification, and return contract.
- `TASKS.md` owns navigation and lightweight delegation board state only.
- `SESSION_HANDOFF.md` owns transient continuation state only.
- `SURFACE.md` owns public contracts only.

Do not treat `TASKS.md`, `SESSION_HANDOFF.md`, or `SURFACE.md` as substitutes for
spec, plan, or task documents.

## Formal Write-Back

When `planning.md` task closure requires formal write-back, record closure facts
in the owning documents:

- Update the task with checklist state, acceptance status, verification result,
  and remaining blockers.
- Update the owning plan with task completion state, output links, dependency
  unlocks, verification result, and changed risks.
- Update the owning spec when scope, constraints, acceptance criteria, or open
  questions changed.

Do not let formal task, plan, and spec state describe different completion
facts.

## Session Handoff

`SESSION_HANDOFF.md` and compression summaries preserve transient state for
continuation only. Preserve digested conclusions, not only file paths, commands,
or pointers to reread.

When context must be compressed or handed off, preserve information in this
order:

1. Architecture decisions and the reasons behind them.
2. Files changed and what changed in each.
3. Current progress state.
4. Remaining TODOs, including for each in-progress delegated task: launch
   instruction, input paths, expected output, and current status.

## Task Mapping

`TASKS.md` and formal task documents do not need a one-to-one mapping.

- Formal task documents are the source of execution scope, acceptance criteria,
  tests, and documentation updates.
- `TASKS.md` is a lightweight navigation board for current focus, priority,
  blockers, delegation state, and exact next action.
- In spec-driven full mode, `TASKS.md` should reference or summarize the active
  formal task instead of copying its full contents.
- In quick-fix mode, full spec/plan/task documents are not required, so a
  `TASKS.md` item may exist without a matching formal task document.
- A single `TASKS.md` parent item may point to a plan or milestone that contains
  multiple formal task documents.

## Public Contracts

Enable or update `SURFACE.md` only when the project exposes a real public
boundary, such as:

- HTTP APIs
- SDK interfaces
- Plugin protocols
- Event or schema contracts

Do not create `SURFACE.md` for internal-only implementation details.

## Delivery Packaging

Before producing a delivery artifact:

- Include only user-facing docs and required runtime/build files.
- Exclude process documents through package allowlists or ignore/exclude files.
- Do not delete process documents from the source tree.
- If a process document is intended for users, move or copy its content into a
  user-facing doc before packaging.

## Formal Document Paths

Normal flow:

- `docs/specs/spec-<slug>.md`
- `docs/plans/<slug>/plan.md`
- `docs/plans/<slug>/tasks/task-<nnn>-<slug>.md`

Superteam flow:

- `working/spec.md`
- `working/plan/plan.md`
- `working/plan/task-NNN/task.md`
- `working/plan-review-results.md`
- `working/plan/task-NNN/changes.md`
- `working/plan/task-NNN/test-results.md`
- `working/plan/task-NNN/implement-review-results.md`

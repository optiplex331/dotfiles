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

Write-back is part of implementation, not optional cleanup.

## Ownership

| Document | Owns |
| --- | --- |
| Global `CLAUDE.md` / `AGENTS.md` | Concise baseline and rule links |
| Project `CLAUDE.md` / `AGENTS.md` | Project workflow, commands, paths, constraints |
| Project rule files | Durable project-specific guidance |
| Spec | Requirements and acceptance criteria |
| Plan | Route, sequencing, dependencies, progress, risks |
| Task | Execution scope, checklist, verification, return contract |
| `TASKS.md` | Current focus, priority, blockers, delegation board, next action |
| `SESSION_HANDOFF.md` | Transient continuation state |
| `SURFACE.md` | Public contracts |

`TASKS.md`, `SESSION_HANDOFF.md`, and `SURFACE.md` do not replace spec, plan, or
task documents.

## Formal Write-Back

When `planning.md` requires formal task closure, record the same completion fact
in each owning document:

- Update the task with checklist state, acceptance status, verification result,
  and remaining blockers.
- Update the owning plan with task completion state, output links, dependency
  unlocks, verification result, and changed risks.
- Update the owning spec when scope, constraints, acceptance criteria, or open
  questions changed.

Do not let formal task, plan, and spec state describe different completion
facts.

## Continuity State

Continuity state is any current knowledge needed to resume without rediscovery:
decisions, changed files, progress, blockers, verification results, or the exact
next action. If that state must survive beyond the current bounded round,
`planning.md` should route the work to `spec-driven-full`.

Use:

- `TASKS.md` for active navigation state. It may summarize formal tasks but not
  replace their scope, acceptance criteria, or test requirements.
- `SESSION_HANDOFF.md` or compression summaries when work crosses a context,
  session, branch, worktree, or agent boundary.

Preserve digested conclusions, not only file paths, commands, or pointers to
reread. Record continuity state in this order:

1. Architecture decisions and the reasons behind them.
2. Files changed and what changed in each.
3. Current progress state.
4. Remaining TODOs, including for each in-progress delegated task: launch
   instruction, input paths, expected output, and current status.

- `TASKS.md` and formal task documents do not need a one-to-one mapping.
- In spec-driven full mode, `TASKS.md` should reference or summarize the active
  formal task instead of copying its full contents.
- In quick-fix mode, `TASKS.md` may only be incidental navigation on an existing
  board. If it is needed to preserve progress, the task is no longer quick-fix.

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
- If process content is user-facing, move or copy it into a user-facing doc
  before packaging.

## Formal Document Paths

Normal flow:

`docs/specs/spec-<slug>.md`, `docs/plans/<slug>/plan.md`,
`docs/plans/<slug>/tasks/task-<nnn>-<slug>.md`

Superteam flow:

`working/spec.md`, `working/plan/plan.md`,
`working/plan/task-NNN/task.md`, `working/plan-review-results.md`,
`working/plan/task-NNN/changes.md`,
`working/plan/task-NNN/test-results.md`,
`working/plan/task-NNN/implement-review-results.md`

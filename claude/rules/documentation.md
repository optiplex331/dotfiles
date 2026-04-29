# Documentation Rules

## Write-Back Rule

Documentation updates are part of implementation, not optional cleanup.

Update related docs in the same task when:

- Behavior changes
- Workflow changes
- Acceptance criteria change
- Public contracts change
- New constraints or assumptions are discovered

## Ownership

- Global `CLAUDE.md` or `AGENTS.md` owns concise baseline rules and links to
  global agent rules.
- Project `CLAUDE.md` or `AGENTS.md` owns project-specific workflow, commands,
  and constraints.
- Project rule files own detailed project-specific guidance.
- Normal-flow `spec` or `working/spec.md` owns requirements.
- Normal-flow `plan` or `working/plan/plan.md` owns route, sequencing, and risks.
- Normal-flow `task` or `working/plan/task-NNN/task.md` owns execution details.
- `TASKS.md` owns navigation and lightweight delegation board state only.
- `SESSION_HANDOFF.md` owns transient state only.
- `SURFACE.md` owns public contracts only.

Do not treat `TASKS.md`, `SESSION_HANDOFF.md`, or `SURFACE.md` as substitutes for
spec, plan, or task documents.

## Session Handoff

`SESSION_HANDOFF.md` owns transient state only.

- Preserve digested conclusions, not only pointers to files to reread.
- For each in-progress delegated task, record the launch instruction, input
  paths, expected output, and current status so it can be re-dispatched without
  re-planning.
- Do not use handoff notes as a substitute for updating the governing spec,
  plan, task, or `TASKS.md`.

## Task Mapping

`TASKS.md` and formal task documents do not need a one-to-one mapping.

- Formal task documents are the source of execution scope, acceptance criteria,
  tests, and documentation updates.
- `TASKS.md` is a lightweight navigation board for current focus, priority,
  blockers, delegation state, and the exact next action.
- In spec-driven full mode, `TASKS.md` should reference or summarize the active
  formal task instead of copying its full contents.
- In quick-fix mode, full spec/plan/task documents are not required, so a
  `TASKS.md` item may exist without a matching formal task document.
- A single `TASKS.md` parent item may point to a plan or milestone that contains
  multiple formal task documents.

## Formal Documents

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

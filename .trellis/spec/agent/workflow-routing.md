# Workflow Routing

## Trellis Default

When a repository has `.trellis/`, use `.trellis/workflow.md` as the operational
workflow. Non-trivial file-changing work should create or continue a Trellis
task under `.trellis/tasks/`.

## Direct Answer

Use a direct answer only for pure Q&A, explanation, lookup, or chat with no file
writes and no durable execution state.

## Inline Escape Hatch

Inline edits are allowed only when the user explicitly asks to skip Trellis for
the current turn, or when no Trellis project exists and the task is small enough
to finish safely in one bounded round.

## Task Expectations

A Trellis task should preserve:

- Goal and acceptance criteria in `prd.md`.
- Implementation context in `implement.jsonl`.
- Check/review context in `check.jsonl`.
- Research under `research/` when discovery needs to survive the conversation.

## Scope Discipline

- Keep coding inside the active task boundary.
- If discovery changes scope, update the PRD/context before continuing.
- One task should produce one reviewable unit when feasible.

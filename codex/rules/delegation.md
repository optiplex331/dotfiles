# Delegation Rules

Use this protocol when context pressure or broad scope would otherwise trap the
main thread in repeated exploration before any action happens.

## Triggers

Use delegation when any of these are true:

- The context window is approaching compression before implementation starts.
- The task spans multiple modules or requires broad exploration.
- `SESSION_HANDOFF.md` would become mostly an index of files to reread.
- The work can be split into independent read, implementation, verification, or
  review slices.

## Main Thread Responsibilities

- Keep the global goal, current stage, task board, decisions, risks, and
  integration state.
- Delegate bounded local exploration, implementation, verification, or review.
- Continue useful non-overlapping work instead of waiting idly.
- Integrate subagent results into the governing task, `TASKS.md`, or
  `SESSION_HANDOFF.md`.
- Close subagents when their result has been consumed.

## Subagent Responsibilities

- Work from a bounded contract, not the whole project context.
- Stay inside assigned read and write scopes.
- Return the result, files read or changed, checks run, risks, and suggested next
  action.
- Avoid changing files outside the assigned ownership scope.

## Contract Template

```text
Objective:
Read scope:
Write scope:
Do not touch:
Required output:
Verification:
Risks to watch:
```

## Result Template

```text
Result:
Files read/changed:
Tests/checks:
Risks:
Suggested next action:
```

## Constraints

- Do not delegate the immediate blocking next step if the main thread cannot make
  progress without it.
- Worker write scopes must be disjoint unless the main thread explicitly
  serializes them.
- `TASKS.md` may contain a lightweight `Delegation Board`, but it must not store
  long analysis.
- `SESSION_HANDOFF.md` must preserve digested conclusions, not only pointers to
  files to reread.
- Delegation does not bypass spec, plan, task, TDD, review, or documentation
  gates.

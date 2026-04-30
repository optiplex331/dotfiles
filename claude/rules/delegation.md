# Delegation Rules

Delegation follows the workflow mode selected by `planning.md`.

Delegation changes execution shape, not ownership of the overall goal. The main
thread always owns the user goal, final judgment, integration state,
verification state, and handoff.

The operating boundary is whether a delegated agent submits bounded results or
owns an engineering task.

## Quick Fix Delegation

In `quick-fix`, delegation is submission-style only.

Quick-fix delegated agents may perform stateless, bounded work such as:

- Read-only scans.
- Repeated checks.
- Candidate findings.
- Reproduction attempts.
- Verification attempts.
- Alternative patch suggestions.

The main thread must be able to evaluate, integrate, verify, and hand off the
result in the same workflow round.

Quick-fix delegated agents must not own durable task state, final integration,
global decisions, or independent reviewable implementation units.

## Spec Driven Delegation

In `spec-driven-full`, delegation may assign task ownership.

The main thread owns orchestration, context hygiene, workflow gates, task graph,
dependency order, integration judgment, verification state, and handoff state.

Delegated agents own bounded tasks with declared inputs, read scope, write
scope, acceptance criteria, verification requirements, and return contracts.

## Avoid

Do not delegate:

- The immediate blocking next step when the main thread cannot make useful
  progress without the result.
- Tiny one-file fixes that the main thread can close faster locally.
- Decisions that require global product, architecture, or workflow judgment.
- Work with unclear read scope, write scope, or expected output.

Also consider delegation when context is approaching compression before
implementation starts and the work can be bounded cleanly.

## Dispatch Contract

For quick-fix submissions, use a lightweight contract:

```text
Goal:
Scope:
Return:
```

For spec-driven tasks, use the task fields defined in `planning.md`.

Add `Do not touch:` or `Risks to watch:` only when the delegation needs those
bounds.

## Result Contract

Delegated agents return:

```text
Result:
Files read/changed:
Checks run:
Risks:
Suggested next action:
```

## Constraints

- Send bounded context, not the whole project history.
- Continue non-overlapping work while delegated agents run when possible.
- Integrate digested results into the governing task or coordination document.
- Reread delegated context only when integration or verification requires it.
- Close delegated agents after their result has been consumed.
- Parallel write scopes must be declared in the owning plan before dispatch, and
  must be disjoint unless the main thread serializes them.
- Delegated agents must not change files outside their assigned scope.
- Coordination state belongs in the documents owned by `documentation.md`.

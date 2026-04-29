# Delegation Rules

Delegation only changes who performs bounded work. It does not change workflow
gates, review gates, documentation write-back, or verification requirements.

## Use

Use delegation when it fits the current workflow mode and materially improves
execution:

- Broad read-only exploration that can be summarized.
- Independent implementation slices with declared ownership.
- Parallel verification or review of an existing diff.
- Context-heavy investigation before the main thread commits to an approach.
- Work that can continue while the main thread does useful non-overlapping work.

Also consider delegation when context is approaching compression before
implementation starts.

## Avoid

Do not delegate:

- The immediate blocking next step when the main thread cannot progress without
  the result.
- Tiny one-file fixes that the main thread can close faster locally.
- Decisions that require global product, architecture, or workflow judgment.
- Work with unclear read scope, write scope, or expected output.

## Mode Fit

Delegation follows `planning.md` mode routing.

- In `quick-fix`, delegate only bounded read-only exploration or parallel checks.
- In `spec-driven-full`, the plan or owning task decides whether the main thread
  or a delegated agent owns execution.

## Main Thread

The main thread owns goal, stage, plan, decisions, risks, integration state, and
handoff state.

Main thread responsibilities:

- Send bounded context, not the whole project history.
- Continue non-overlapping work while delegated agents run.
- Integrate digested results into the governing task or coordination document.
- Reread delegated context only when integration or verification requires it.
- Close delegated agents after their result has been consumed.

## Dispatch Contract

Formal tasks use the task fields defined in `planning.md`. For ad-hoc
delegation, use a short contract:

```text
Objective:
Read scope:
Write scope:
Required output:
Verification:
```

Add `Do not touch:` or `Risks to watch:` only when the task needs those bounds.

## Result Contract

Delegated agents must return:

```text
Result:
Files read/changed:
Checks run:
Risks:
Suggested next action:
```

## Constraints

- Worker write scopes must be disjoint unless the main thread serializes them.
- Parallel worker write scopes must be declared in the owning plan or task before
  workers start.
- Delegated agents must not change files outside their assigned ownership scope.
- Coordination state belongs in the documents owned by `documentation.md`.

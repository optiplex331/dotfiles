# Delegation

## Ownership

The main thread owns final judgment, integration, verification, and handoff.
Delegation changes execution shape, not ownership of the user goal.

## When To Delegate

Delegate when the work can be bounded cleanly and the delegated result can
materially advance the task:

- Independent read-only scans.
- Repeated checks or reproduction attempts.
- Candidate findings.
- Bounded implementation slices with disjoint write scopes.
- Verification attempts.

Do not delegate the immediate blocking next step when the main thread cannot
make useful progress without the result.

## Dispatch Contract

For lightweight submissions:

```text
Goal:
Scope:
Return:
```

For Trellis implementation tasks, use the active task PRD plus explicit read
scope, write scope, acceptance criteria, verification requirements, and return
contract.

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
- Integrate digested results into the governing Trellis task or coordination
  document.
- Close delegated agents after their result has been consumed.
- Parallel write scopes must be declared before dispatch and must be disjoint
  unless the main thread serializes them.

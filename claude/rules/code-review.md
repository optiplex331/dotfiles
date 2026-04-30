# Code Review Rules

Review is a risk gate for bugs, regressions, missing tests, safety issues, and
contract drift before work is closed.

## Triggers

Use the full review loop for:

- Explicit review requests.
- Existing task-scoped diffs.
- Changes touching public contracts, shared modules, persistence, security,
  data-loss risk, cross-module behavior, or user-facing workflows.

Small quick-fix changes still need self-review, verification, and a concise diff
summary.

## Review Loop

1. Start with the native review workflow available in the current agent
   environment and provide the task-scoped `git diff` as context.
2. List unrelated dirty files separately. Do not review or modify them unless
   explicitly requested.
3. Analyze feedback and decide what must change.
4. Make the changes.
5. Run the same review workflow again with the updated diff.
6. Iterate for up to 3 rounds if issues remain.

If no native review command is available, perform a manual code-review pass and
state that limitation.

## Findings

Prioritize findings: bugs, behavioral regressions, missing tests, security or
data-loss risks, contract and documentation drift.

Present findings first, ordered by severity, with file and line references.
Keep summaries secondary.

## Closure

- Existing task-scoped diffs or explicit review requests go through review before
  new planning or implementation.
- After implementation, review the resulting diff when the trigger conditions
  apply.
- A reviewed task is not closed until required fixes are applied or remaining
  risks are explicitly documented.

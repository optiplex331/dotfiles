# Review And Verification

## Verification

- Testable code tasks default to TDD.
- Write test or verification requirements before coding starts.
- Verification order is `unit -> integration -> e2e` when all layers apply.
- If verification finds a bug, reproduce it with a failing test first, then fix.
- Scale checks with risk and blast radius.

## Review

Use the native review workflow available in the current agent environment when:

- The user explicitly asks for review.
- Existing task-scoped diffs are present.
- Changes touch public contracts, shared modules, persistence, security,
  data-loss risk, cross-module behavior, or user-facing workflows.

If no native review command is available, perform a manual code-review pass and
state that limitation.

## Findings

Prioritize findings in this order:

1. Bugs and behavioral regressions.
2. Missing tests or insufficient verification.
3. Security or data-loss risks.
4. Contract and documentation drift.

Present findings first, ordered by severity, with file and line references.

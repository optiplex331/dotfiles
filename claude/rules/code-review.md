# Code Review Rules

## Review Loop

When the user asks for review or requests code changes:

1. Start with the native review workflow available in the current agent
   environment and provide the current `git diff` as context.
2. Analyze the review feedback and decide what needs to change.
3. Make the code changes.
4. Run the same review workflow again with the same thread or context and the
   new diff.
5. If issues remain, continue iterating for up to 3 rounds.

If no native review command is available, perform a manual code-review pass and
state that limitation.

## Review Stance

When asked for a review, prioritize:

- Bugs
- Behavioral regressions
- Missing tests
- Security or data-loss risks
- Contract and documentation drift

Present findings first, ordered by severity and grounded in file and line
references. Keep summaries secondary.

## Interaction With Spec-Driven Work

- Existing diffs or explicit review requests go through review first.
- New development requests go through the planning gates first, then review the
  resulting diff after implementation.

# Global Codex Instructions

## Git Commit Convention

Follow **Angular Commit Message Convention**: `<type>(<scope>): <summary>`

Types: `feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore` `revert`
- Breaking change: `feat!:` + `BREAKING CHANGE:` footer
- Subject: imperative, no period, ≤72 chars, English

---

## Git Workflow

- Do not use `main` for non-trivial work. Use one branch per task.
- Before making any non-trivial edit, check the current branch and create the task branch first.
- Do not start editing on `main` and branch later, even if the changes are still uncommitted.
- If code and docs belong to the same task, keep them on the same branch.
- If the work no longer matches the current branch goal, start a new branch.
- If a follow-up cleanup or correction is needed after merge, use a new branch unless the user explicitly asks to work directly on `main`.
- Before committing new untracked config or environment files, check whether they should remain local and whether `.gitignore` should handle them instead.
- Prefer `git worktree` when multiple tasks need to stay in progress at the same time.

---

## Documentation Update Rule

- Update related documentation proactively as code changes and features evolve.
- Treat documentation updates as part of the implementation, not as optional cleanup.
- When behavior, interfaces, workflows, assumptions, or usage change, update the relevant docs in the same task.
- Decide which documentation files to update based on the project's own structure and conventions.
- Do not defer documentation if it would leave the project in a misleading or incomplete state.

---

## Code Review Workflow (Codex)

When the user asks for a review or requests code changes, follow this process:

1. Start a review with `/codex:review`, sending `git diff` as context.
2. Analyze the review feedback and decide what needs to change.
3. Make the code changes.
4. After updating the code, run `/codex:review` again with the same `threadId` and the new `diff` for re-review.
5. If Codex still finds issues, continue iterating for up to 3 rounds.

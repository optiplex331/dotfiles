# Git And Branching

## Branches

- Respect the repository's existing branch strategy.
- Create, switch, merge, rebase, commit, or push only when the user asks or the
  active workflow explicitly requires it.
- Do not use `main` for non-trivial work. Use one branch per task.
- Branch names use `<type>/<short-slug>`, for example `feat/oauth-login`,
  `fix/api-timeout`, or `docs/agent-rules-cleanup`.
- Prefer `git worktree` when another dirty branch must remain untouched.

## Dirty Worktree

- Before file-changing work, inspect `git status --short`.
- Never discard existing user changes unless explicitly requested.
- If dirty files are unrelated, leave them untouched and work in a clean branch
  or worktree when needed.
- Before committing new untracked config, environment files, secrets, tokens, or
  machine-specific paths, check whether they are intentional.

## Commits

Use Angular commit format:

```text
<type>(<scope>): <summary>
```

Allowed types: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`,
`ci`, `chore`, `revert`.

- Summary is English, imperative, no period, 72 characters or fewer.
- Breaking changes use `feat!:` plus a `BREAKING CHANGE:` footer.
- Do not push unless the user asks or the active workflow explicitly requires it.

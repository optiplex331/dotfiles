# Global Agent Instructions

These instructions are the shared global baseline for agentic coding tools across
repositories. Project `CLAUDE.md` or `AGENTS.md` files may add local workflow,
paths, commands, and stricter rules, but they must not silently weaken this
baseline.

## Rule Loading

Read the matching rule file in `~/.claude/rules/` or `~/.codex/rules/` before
acting in that area:

- `planning.md`: mode routing, spec-driven gates, plans, and tasks
- `code-review.md`: review loop and findings handling
- `documentation.md`: documentation ownership and write-back
- `delegation.md`: long-context and delegated-agent coordination
- `english.md`: passive English coaching when applicable

Apply rules in this order:

1. Global `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md`
2. Matching global `~/.claude/rules/*.md` or `~/.codex/rules/*.md`
3. Project `CLAUDE.md` or `AGENTS.md`
4. Project rule files, if the project defines them

When rules conflict, follow the stricter rule. A project may relax a global rule
only when it states the reason explicitly.

## Git Workflow

### Commit Messages

Use **Angular Commit Message Convention**: `<type>(<scope>): <summary>`

Types: `feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore` `revert`

- Breaking change: `feat!:` plus a `BREAKING CHANGE:` footer
- Subject: imperative, no period, 72 characters or fewer, English

### Branching

- Keep `main` stable and use `dev` as the integration branch for non-trivial
  work.
- Before non-trivial edits, work on a matching task branch; otherwise create one
  from an up-to-date `dev`.
- Merge task branches back to `dev` only after verification and review.
- Re-verify `dev` after integration, then promote it to `main` only when the
  integrated state is verified.
- For urgent fixes from `main`, merge or cherry-pick the fix back into `dev`.
- Keep branch scope aligned with the task; code and docs for the same task stay
  together, and scope changes get a new branch.
- Before committing new untracked config or environment files, check whether
  they should remain local or be ignored.
- Prefer task branch names like `type/<task-id>-<slug>` or `task/<slug>`.
- Prefer `git worktree` when `main`, `dev`, or multiple task branches need to
  stay checked out in parallel.

Keep this file short. Put detailed durable rules in `~/.claude/rules/*.md` or
`~/.codex/rules/*.md`.

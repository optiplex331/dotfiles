# Global Agent Instructions

These instructions are the shared global baseline for agentic coding tools across
repositories. Project `CLAUDE.md` or `AGENTS.md` files may add local workflow,
paths, commands, and stricter rules, but they must not silently weaken this
baseline.

## Rule Loading

Read the matching rule file in `~/.claude/rules/` or `~/.codex/rules/` before
acting in that area:

- `planning.md`: mode routing, spec-driven gates, plans, and tasks
- `testing.md`: TDD and verification order
- `code-review.md`: review loop and findings handling
- `documentation.md`: documentation ownership and write-back
- `delegation.md`: long-context and delegated-agent coordination
- `architecture.md`: architecture and public contract guidance
- `english.md`: passive English coaching when applicable

Apply rules in this order:

1. Global `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md`
2. Matching global `~/.claude/rules/*.md` or `~/.codex/rules/*.md`
3. Project `CLAUDE.md` or `AGENTS.md`
4. Project rule files, if the project defines them

When rules conflict, follow the stricter rule. A project may relax a global rule
only when it states the reason explicitly.

## Commit Convention

Follow **Angular Commit Message Convention**: `<type>(<scope>): <summary>`

Types: `feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore` `revert`

- Breaking change: `feat!:` plus a `BREAKING CHANGE:` footer
- Subject: imperative, no period, 72 characters or fewer, English

## Git Workflow

- Do not use `main` for non-trivial work. Use one branch per task.
- Before making any non-trivial edit, check the current branch and create the
  task branch first.
- Do not start editing on `main` and branch later, even when changes are still
  uncommitted.
- If code and docs belong to the same task, keep them on the same branch.
- If the work no longer matches the current branch goal, start a new branch.
- Before committing new untracked config or environment files, check whether
  they should remain local or be ignored.
- Prefer `git worktree` when multiple tasks need to stay in progress.

## Default Workflow

Non-trivial development defaults to spec-driven mode. Both quick-fix and
spec-driven-full exist to shape work into execution units that can be closed,
verified, reviewed, and handed off by agents.

`spec -> plan -> task -> code -> unit -> integration -> e2e`

Use quick-fix only when the main agent can complete the work in one bounded
round without durable task documents. Existing diffs or explicit review requests
go through the review workflow first.

## Documentation And Review

- Update related docs whenever behavior, interfaces, workflows, assumptions, or
  usage change.
- Treat documentation write-back as part of implementation, not optional cleanup.
- When asked for review or when code changes are requested, use the native
  review workflow available in the current agent environment, then iterate on
  findings with the updated diff for up to 3 rounds.

Keep this file short. Put detailed durable rules in `~/.claude/rules/*.md` or
`~/.codex/rules/*.md`.

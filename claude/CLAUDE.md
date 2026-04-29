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

- Keep `main` stable and use `dev` as the integration branch for non-trivial
  work.
- Do not work directly on `main`; create task branches from `dev` and merge them
  back to `dev` after verification and review.
- If already on a task branch that matches the current goal, continue there;
  otherwise create a task branch from an up-to-date `dev`.
- After integrating task branches into `dev`, re-verify the integrated state with
  checks scaled to risk.
- Promote `dev` to `main` only after the integrated state is verified.
- For urgent fixes from `main`, merge or cherry-pick the fix back into `dev`.
- Prefer task branch names like `type/<task-id>-<slug>` or `task/<slug>`.
- Before making any non-trivial edit, check the current branch and create the
  task branch first.
- Do not start editing on `main` and branch later, even when changes are still
  uncommitted.
- If code and docs belong to the same task, keep them on the same branch.
- If the work no longer matches the current branch goal, start a new branch.
- Before committing new untracked config or environment files, check whether
  they should remain local or be ignored.
- Prefer `git worktree` when `main`, `dev`, or multiple task branches need to
  stay checked out in parallel.

## Default Workflow

Non-trivial development defaults to spec-driven mode. Both quick-fix and
spec-driven-full exist to shape work into execution units that can be closed,
verified, reviewed, and handed off by agents.

`spec -> plan -> task -> code -> unit -> integration -> e2e`

Use quick-fix only when the main agent can complete the work in one bounded
round, with no durable task state, no delegated implementation, and no parallel
write scopes. Existing task-scoped diffs or explicit review requests go through
the review workflow first.

## Documentation And Review

- Update related docs whenever behavior, interfaces, workflows, assumptions, or
  usage change.
- Treat documentation write-back as part of implementation, not optional cleanup.
- For explicit review requests, existing task-scoped diffs, or code changes that
  touch public contracts, shared modules, persistence, security, data-loss risk,
  cross-module behavior, or user-facing workflows, use the native review
  workflow available in the current agent environment, then iterate on findings
  with the updated diff for up to 3 rounds.

Keep this file short. Put detailed durable rules in `~/.claude/rules/*.md` or
`~/.codex/rules/*.md`.

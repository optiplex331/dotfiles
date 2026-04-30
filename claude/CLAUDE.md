# Global Agent Instructions

Shared baseline for agentic coding tools. Project `CLAUDE.md` or `AGENTS.md`
files may add local workflow, paths, commands, and stricter rules, but must not
silently weaken this baseline.

## Rule Loading

Before acting, read only the matching files from `~/.claude/rules/` or
`~/.codex/rules/`.

| Rule | Owns |
| --- | --- |
| `planning.md` | Workflow routing, spec/plan/task gates, closure, verification order |
| `code-review.md` | Review triggers, loop, findings, closure |
| `documentation.md` | Ownership, write-back, continuity state, handoff |
| `delegation.md` | Delegated-agent permissions, dispatch, coordination |
| `english.md` | Passive English coaching |

Apply rules in this order:

1. Global `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md`
2. Matching global `~/.claude/rules/*.md` or `~/.codex/rules/*.md`
3. Project `CLAUDE.md` or `AGENTS.md`
4. Project rule files, if the project defines them

When rules conflict, follow the stricter rule. A project may relax this baseline
only when it states the reason explicitly.

## Workflow Dispatch

Before implementation, use `planning.md` to choose the smallest workflow that can
still be closed, verified, reviewed, documented, and handed off cleanly.

Existing task-scoped diffs and explicit review requests enter the review
workflow before new planning or implementation.

## Git Workflow

- Keep `main` stable; use `dev` as the integration branch for non-trivial work.
- Do non-trivial work on a matching task branch from up-to-date `dev`.
- Merge task branches to `dev` only after verification and review.
- Re-verify `dev` before promoting verified integrated state to `main`.
- Merge or cherry-pick urgent fixes from `main` back to `dev`.
- Keep branch scope aligned with task scope; split branches when scope changes.
- Keep code and docs for the same task together.
- Check new untracked config or environment files before committing them.
- Prefer branch names like `type/<task-id>-<slug>` or `task/<slug>`.
- Prefer `git worktree` when several long-lived branches must stay checked out.

Commits use Angular format: `<type>(<scope>): <summary>`.

- Types: `feat` `fix` `docs` `refactor` `perf` `test` `build` `ci` `chore`
  `revert`.
- Summary: English, imperative, no period, 72 characters or fewer.
- Breaking changes: use `feat!:` plus a `BREAKING CHANGE:` footer.

Keep this file short. Put detailed durable rules in `~/.claude/rules/*.md` or
`~/.codex/rules/*.md`.

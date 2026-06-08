# Global Agent Instructions

## Communication & Collaboration

- Use Chinese for casual discussion and task summaries; use English for code, technical identifiers, commit messages, and project documentation.
- Be concise, but include the technical context needed to make answers useful.
- Respect task boundaries: stop at planning, inspection, comparison, cleanup, or discussion when requested.
- Ask before acting only when ambiguity could cause meaningful rework; otherwise make a reasonable assumption and proceed.
- Treat user-proposed decisions and approval-seeking questions as requests for critical evaluation: risks, alternatives, and a clear recommendation.
- Prefer one focused context-gathering pass, then act.
- In learning materials, avoid vague jargon and document self-description; after a reading path, go directly into concrete objects, actions, sequences, commands, checks, and failure modes.

## Repository Workflow

- Before changing files, inspect the repository workflow and keep edits scoped to the request.
- In Git repositories, check status first and preserve user work: do not overwrite, revert, discard, or stage unrelated changes.
- The agent may create or switch branches, stage task-scoped changes, and commit completed work when appropriate.
- Do not commit unless the user requested an implementation task, explicitly asked for a commit, or committing is clearly part of the workflow.
- Do not create new worktrees, push, open pull requests, publish externally, or run destructive Git commands such as `git reset --hard` or `git push --force` unless explicitly asked.
- Follow the repository's commit convention; default to Conventional Commits (`<type>(<scope>): <summary>`).

## Tooling

- Use the best-fit tool and follow the repository's existing tooling conventions.
- Prefer project-local or ephemeral tools before modifying the global environment.
- Ask before installing global tools, changing system configuration, or enabling external services.
- For Python outside a project environment, prefer `uv run --with <package> ...`.
- For JavaScript/TypeScript, follow the declared package manager; if none is declared, prefer `pnpm`.

## Implementation & Verification

- Verify files, configs, commands, and project state from real sources; do not rely solely on README files, memory, or assumptions.
- Match existing project style and prefer the simplest correct solution for the user's actual goal.
- Avoid unrelated refactors, abstractions, config, docs, or architecture changes.
- Do not add fallbacks, retries, heuristics, shims, or post-processing unless required by the request or a verified failure mode.
- Prefer fixing the root cause. If a fallback or workaround is necessary, keep it narrow, explicit, observable, and explain the risk.
- Run the most relevant available verification after changes.
- Before claiming completion, check the result against the original request and briefly review for bugs, excessive complexity, and unresolved risk.
- If verification cannot be run or fails, explain why and state the remaining risk.

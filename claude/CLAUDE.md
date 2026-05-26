# Global Agent Instructions

## Language

- Use Chinese for casual discussion.
- Use English for code, technical identifiers, commit messages, and project documentation unless the project or user request clearly uses Chinese.

## Repository Workflow

- Before changing files, inspect the repository's local workflow and keep edits scoped to the request.
- In Git repositories, check status first and preserve user work: do not overwrite, revert, discard, or stage unrelated changes.
- Agent drive the local Git workflow: create or switch branches, stage task-scoped changes, and commit completed work.
- Do not push to remotes, create pull requests, publish externally, or run destructive Git commands such as `git reset --hard`, `git push --force` unless explicitly asked.
- When committing, follow the repository's commit convention; default to Conventional Commits (`<type>(<scope>): <summary>`).

## Tooling

- Prefer the best-fit tool for the task and follow the repository's existing tooling conventions.
- If a required tool is missing, prefer project-local or ephemeral usage before modifying global environment.
- Ask before installing global tools, changing system-level configuration, or enabling external services.
- For Python outside a project environment, prefer `uv run --with <package> ...` when dependencies are missing.
- For JavaScript/TypeScript, follow the declared package manager. If none is declared, prefer `pnpm`.

## Implementation & Verification

- Match existing project style and conventions; do not impose unrelated formatting preferences.
- Keep changes focused on the requested behavior. Avoid opportunistic refactors unless needed.
- Run the most relevant available verification after changes.
- If verification cannot be run, explain why and state the remaining risk.

## Collaboration Style

- Start from the underlying goal; clarify when ambiguity could cause meaningful rework.
- Treat user-proposed decisions as hypotheses; challenge weak assumptions and recommend a better path when one exists.
- Treat approval-seeking questions as requests for critical evaluation: risks, alternatives, and a clear recommendation.
- Prefer one focused context-gathering pass, then act.
- Be concise, but include the technical context and mechanisms needed to make answers useful.
- Do not create standalone docs, READMEs, config files, or broad architectural changes unless explicitly asked or required.
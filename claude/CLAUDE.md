# Global Agent Instructions

This file is the short cross-project entry point installed into
`~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`.

## User Profile

- Developer working across JavaScript/React and Python ecosystems
- macOS environment: zsh, tmux, Neovim (LazyVim), Ghostty terminals
- Tools: Claude Code, Codex, VS Code
- Bilingual: Chinese (native) and English — match the language of the current project or conversation; default to Chinese for casual discussion, English for code and docs

## Instruction Precedence

- Prefer the current repository's local instructions over this file, including
  `AGENTS.md`, `CLAUDE.md`, and project docs.
- Treat Trellis as project-scoped. Use Trellis only when the current repository
  contains `.trellis/`; then follow that project's Trellis specs and tasks as
  its durable source of truth.

## Defaults

- Pure Q&A or explanation can be answered directly.
- For file changes, inspect the repository's local workflow first and keep edits
  scoped to the user's request.
- Respect the repository's branch strategy. Create, switch, commit, or push only
  when the user asks or the active workflow requires it.
- Use Angular commit format (`<type>(<scope>): <summary>`) unless the repository
  specifies a different convention.

## Working Style

- Be concise — no preamble, no restating the question, no trailing summaries unless the task is complex
- Prefer one round-trip: gather context in parallel (grep + reads), then act
- When the user gives a brief prompt, infer intent from the current directory and project context
- For multi-step work, use tasks to track progress; don't create tasks for single-step work
- Never create files (docs, READMEs, configs) unless explicitly asked
- Match existing code style in each project — don't impose a global formatter preference

Keep this file short. Durable, project-specific behavior belongs in the project
itself, either in local agent docs or in that project's Trellis specs.

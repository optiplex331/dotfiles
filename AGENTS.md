# AGENTS.md

Project instructions for the personal macOS dotfiles repository.

## Repository Context

- This repo manages developer environment configuration and renders or symlinks files into `$HOME` with `scripts/restore.sh`.
- Keep project documentation and technical identifiers in English unless updating existing Chinese user-facing README content.
- After editing any managed config, run `bash scripts/restore.sh` to refresh local links.
- Existing non-symlink destination files are backed up to `~/.dotfiles_backup/` by the restore script.

## Load On Demand

| Scenario | Read |
| --- | --- |
| Full setup, tool overview, directory structure, shortcuts, and maintenance | `README.md` |
| New machine bootstrap flow | `scripts/setup.sh` |
| Symlink/render targets and restore behavior | `scripts/restore.sh` |
| Homebrew package set | `Brewfile` |
| Neovim / LazyVim configuration | `nvim/` |
| VS Code settings and keybindings | `vscode/` |
| Global Claude/Codex interaction rules | `claude/CLAUDE.md` |
| Codex local configuration template | `codex/config.toml` |

## Editing Rules

- Add new managed configs under the matching tool directory, then add the corresponding `link <src> <dst>` entry in `scripts/restore.sh`.
- Prefer project-local commands and scripts; do not modify global machine state directly unless the task explicitly requires it.
- Before committing, check `git status --short` and keep commits scoped to the requested dotfiles change.

# CLAUDE.md

This file provides guidance to agentic coding tools when working with code in this repository.

## What this repo is

Personal macOS developer environment dotfiles. All configs are symlinked into
`$HOME` via `scripts/restore.sh`.

This repository is now Trellis-managed. Agent workflow, durable rules, task
state, and session memory live under `.trellis/`. Trellis-generated platform
adapters live under `.claude/`, `.codex/`, and `.agents/skills/`.

For agent-system changes, read:

- `.trellis/workflow.md`
- `.trellis/spec/agent/index.md`
- `.trellis/spec/dotfiles/index.md`

## Key scripts

| Script | Purpose |
|--------|---------|
| `scripts/setup.sh` | Bootstrap a new machine (SSH → Homebrew → clone → restore → brew bundle) |
| `scripts/restore.sh` | (Re-)create all symlinks idempotently and refresh path-aware configs; existing non-symlink files are backed up to `~/.dotfiles_backup/` |

**Apply changes after editing any config:**
```bash
bash scripts/restore.sh
```

## Adding a new tool config

1. Place the config file/directory under a matching tool subdirectory in this repo.
2. Add a `link <src> <dst>` line in `scripts/restore.sh`.
3. Run `bash scripts/restore.sh`.

## Trellis

```bash
# List Trellis packages/specs
python3 ./.trellis/scripts/get_context.py --mode packages

# List active tasks
python3 ./.trellis/scripts/task.py list

# Validate a task's context manifests
python3 ./.trellis/scripts/task.py validate <task-dir>
```

Use `npx -y @mindfoldhq/trellis@rc update` to refresh Trellis-managed files
after reviewing upstream changes. Do not run `scripts/restore.sh` against the
live home directory unless that is the intended operation.

## Install / update software

```bash
# Install everything from Brewfile
brew bundle --file=~/Code/dotfiles/Brewfile

# Update all Homebrew packages
brew update && brew upgrade && brew cleanup --prune=all
```

## Symlink map (restore.sh targets)

The repository root `AGENTS.md` is a symlink to this file, so project guidance
must stay neutral enough for both `CLAUDE.md` and `AGENTS.md` readers.

| Repo path | Symlinked to |
|-----------|-------------|
| `zsh/.zshrc` | `~/.zshrc` |
| `vim/vimrc` | `~/.vimrc` |
| `nvim/` | `~/.config/nvim` |
| `kitty/` | `~/.config/kitty` |
| `ghostty/` | `~/.config/ghostty` |
| `tmux/tmux.conf.local` | `~/.tmux.conf.local` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/ignore` | `~/.config/git/ignore` |
| `starship/starship.toml` | `~/.config/starship.toml` |
| `lazygit/` | `~/.config/lazygit` |
| `yazi/` | `~/.config/yazi` |
| `lazydocker/config.yml` | `~/Library/Application Support/lazydocker/config.yml` |
| `cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| `cursor/keybindings.json` | `~/Library/Application Support/Cursor/User/keybindings.json` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `.trellis/` | `~/.trellis` |
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `.claude/agents/trellis-*.md` | `~/.claude/agents/trellis-*.md` |
| `.claude/commands/trellis/` | `~/.claude/commands/trellis` |
| `.claude/skills/trellis-*/` | `~/.claude/skills/trellis-*` |
| `codex/config.toml` | rendered to `~/.codex/config.toml` with `{{DOTFILES_DIR}}` replaced by the current repo path |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `.codex/agents/trellis-*.toml` | `~/.codex/agents/trellis-*.toml` |
| `.agents/skills/trellis-*/` | `~/.agents/skills/trellis-*` |

## Neovim

Config is LazyVim-based (`nvim/`). Structure:
- `lua/config/` — options, keymaps, autocmds, lazy bootstrap
- `lua/plugins/` — one file per plugin override/addition
- `lazyvim.json` — enabled LazyVim extras

Update plugins from within Neovim: `:Lazy update` / `:TSUpdate`

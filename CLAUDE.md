# CLAUDE.md

This file provides guidance to agentic coding tools when working with code in this repository.

## What this repo is

Personal macOS developer environment dotfiles. All configs are symlinked into `$HOME` via `scripts/restore.sh` — the repo itself lives at `~/Code/dotfiles`.

## Key scripts

| Script | Purpose |
|--------|---------|
| `scripts/setup.sh` | Bootstrap a new machine (SSH → Homebrew → clone → restore → brew bundle) |
| `scripts/restore.sh` | (Re-)create all symlinks idempotently and refresh path-aware configs; existing non-symlink files are backed up to `~/.dotfiles_backup/` |

**Apply changes after editing any config:**
```bash
bash ~/Code/dotfiles/scripts/restore.sh
```

## Adding a new tool config

1. Place the config file/directory under a matching tool subdirectory in this repo.
2. Add a `link <src> <dst>` line in `scripts/restore.sh`.
3. Run `bash scripts/restore.sh`.

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
| `claude/statusline.sh` | `~/.claude/statusline.sh` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/rules/*.md` | `~/.claude/rules/*.md` |
| `claude/agents/` | `~/.claude/agents` |
| `codex/config.toml` | rendered to `~/.codex/config.toml` with `{{DOTFILES_DIR}}` replaced by the current repo path |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `codex/agents/` | `~/.codex/agents` |
| `codex/rules/*.md` | `~/.codex/rules/*.md` |

## Neovim

Config is LazyVim-based (`nvim/`). Structure:
- `lua/config/` — options, keymaps, autocmds, lazy bootstrap
- `lua/plugins/` — one file per plugin override/addition
- `lazyvim.json` — enabled LazyVim extras

Update plugins from within Neovim: `:Lazy update` / `:TSUpdate`

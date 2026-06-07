#!/usr/bin/env bash
# Create all symlinks from dotfiles repo to $HOME.
# Safe to re-run: existing non-symlink files are backed up first.

set -Eeuo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log()  { printf '\033[0;32m[restore]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[restore]\033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m[restore]\033[0m %s\n' "$*" >&2; exit 1; }

backup_existing() {
  local dst="$1"
  local backup="$BACKUP_DIR/${dst#"$HOME"/}"

  mkdir -p "$(dirname "$backup")"
  warn "Backing up: $dst -> $backup"
  mv "$dst" "$backup"
}

# Symlink helper: link src (relative to DOTFILES) to dst (relative to HOME)
link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir; dir="$(dirname "$dst")"

  [ -e "$src" ] || die "missing source: $src"

  mkdir -p "$dir"

  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    backup_existing "$dst"
  fi

  ln -s "$src" "$dst"
  log "linked: $dst"
}

unlink_obsolete() {
  local dst="$HOME/$1"

  if [ -L "$dst" ]; then
    rm -f "$dst"
    log "removed obsolete link: $dst"
  fi
}

# ── Shell ──────────────────────────────────────────────────────────────────
unlink_obsolete .zprofile
link zsh/.zshrc         .zshrc

# ── Editors ───────────────────────────────────────────────────────────────
link vim/vimrc         .vimrc
link nvim              .config/nvim

# ── Terminal ──────────────────────────────────────────────────────────────
link kitty             .config/kitty
link ghostty           .config/ghostty
link tmux/tmux.conf.local .tmux.conf.local

# ── Git ───────────────────────────────────────────────────────────────────
link git/gitconfig     .gitconfig
link git/ignore        .config/git/ignore

# ── Prompt ────────────────────────────────────────────────────────────────
link starship/starship.toml .config/starship.toml

# ── Tools ─────────────────────────────────────────────────────────────────
link lazygit           .config/lazygit
link yazi              .config/yazi
link lazydocker/config.yml "Library/Application Support/lazydocker/config.yml"

# ── Obsolete Cursor config ────────────────────────────────────────────────
unlink_obsolete "Library/Application Support/Cursor/User/settings.json"
unlink_obsolete "Library/Application Support/Cursor/User/keybindings.json"

# ── VS Code ───────────────────────────────────────────────────────────────
link vscode/settings.json    "Library/Application Support/Code/User/settings.json"
link vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"

# ── Claude Code ───────────────────────────────────────────────────────────
link claude/statusline.sh .claude/statusline.sh
link claude/CLAUDE.md .claude/CLAUDE.md
unlink_obsolete .claude/agents
unlink_obsolete .claude/rules

# ── Codex ─────────────────────────────────────────────────────────────────
unlink_obsolete .Codex/statusline.sh
unlink_obsolete .Codex/AGENTS.md
unlink_obsolete .codex/agents
unlink_obsolete .codex/rules
link codex/config.toml .codex/config.toml
link claude/CLAUDE.md .codex/AGENTS.md

log "Done."

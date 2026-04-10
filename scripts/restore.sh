#!/usr/bin/env bash
# Create all symlinks from dotfiles repo to $HOME.
# Safe to re-run: existing non-symlink files are backed up first.

set -Eeuo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log()  { printf '\033[0;32m[restore]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[restore]\033[0m %s\n' "$*"; }

# Symlink helper: link src (relative to DOTFILES) to dst (relative to HOME)
link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir; dir="$(dirname "$dst")"

  mkdir -p "$dir"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    warn "Backing up: $dst -> $BACKUP_DIR/$(basename "$dst")"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
  fi

  ln -sfn "$src" "$dst"
  log "linked: $dst"
}

# ── Shell ──────────────────────────────────────────────────────────────────
link zsh/zshrc         .zshrc

# ── Editors ───────────────────────────────────────────────────────────────
link vim/vimrc         .vimrc
link nvim              .config/nvim

# ── Terminal ──────────────────────────────────────────────────────────────
link kitty             .config/kitty
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

# ── Cursor ────────────────────────────────────────────────────────────────
link cursor/settings.json    "Library/Application Support/Cursor/User/settings.json"
link cursor/keybindings.json "Library/Application Support/Cursor/User/keybindings.json"

log "Done."

#!/usr/bin/env bash
# Create all symlinks from dotfiles repo to $HOME.
# Safe to re-run: existing non-symlink files are backed up first.

set -Eeuo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log()  { printf '\033[0;32m[restore]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[restore]\033[0m %s\n' "$*"; }

backup_existing() {
  local dst="$1"
  local backup="$BACKUP_DIR/${dst#$HOME/}"

  mkdir -p "$(dirname "$backup")"
  warn "Backing up: $dst -> $backup"
  mv "$dst" "$backup"
}

# Symlink helper: link src (relative to DOTFILES) to dst (relative to HOME)
link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir; dir="$(dirname "$dst")"

  mkdir -p "$dir"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    backup_existing "$dst"
  fi

  ln -sfn "$src" "$dst"
  log "linked: $dst"
}

# Render helper: keep machine-local Codex config, but refresh the dotfiles repo path.
render_codex_config() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir tmp
  dir="$(dirname "$dst")"

  mkdir -p "$dir"
  tmp="$(mktemp "${TMPDIR:-/tmp}/dotfiles-render.XXXXXX")"

  awk -v dotfiles="$DOTFILES" '
    /^\[projects\.".*\/dotfiles"\]$/ {
      print "[projects.\"" dotfiles "\"]"
      next
    }
    { print }
  ' "$src" > "$tmp"

  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    if cmp -s "$tmp" "$dst"; then
      rm -f "$tmp"
      log "unchanged: $dst"
      return
    fi

    backup_existing "$dst"
  fi

  mv "$tmp" "$dst"
  log "rendered: $dst"
}

# ── Shell ──────────────────────────────────────────────────────────────────
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

# ── Cursor ────────────────────────────────────────────────────────────────
link cursor/settings.json    "Library/Application Support/Cursor/User/settings.json"
link cursor/keybindings.json "Library/Application Support/Cursor/User/keybindings.json"

# ── VS Code ───────────────────────────────────────────────────────────────
link vscode/settings.json    "Library/Application Support/Code/User/settings.json"

# ── Claude Code ───────────────────────────────────────────────────────────
link claude/settings.json        .claude/settings.json
link claude/statusline-command.sh .claude/statusline-command.sh
link claude/CLAUDE.md            .claude/CLAUDE.md
link claude/agents               .claude/agents
# Skills 不由本仓库管理

# ── Codex ─────────────────────────────────────────────────────────────────
render_codex_config codex/config.toml .codex/config.toml
link codex/AGENTS.md             .codex/AGENTS.md

log "Done."

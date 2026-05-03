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

unlink_obsolete() {
  local dst="$HOME/$1"

  if [ -L "$dst" ]; then
    rm -f "$dst"
    log "removed obsolete link: $dst"
  fi
}

# Render helper: replace explicit template placeholders before installing.
render_codex_config() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir tmp
  dir="$(dirname "$dst")"

  mkdir -p "$dir"
  tmp="$(mktemp "${TMPDIR:-/tmp}/dotfiles-render.XXXXXX")"

  if ! DOTFILES_FOR_TEMPLATE="$DOTFILES" awk '
    BEGIN {
      dotfiles = ENVIRON["DOTFILES_FOR_TEMPLATE"]
      placeholder = "{{DOTFILES_DIR}}"
    }
    {
      while ((idx = index($0, placeholder)) > 0) {
        $0 = substr($0, 1, idx - 1) dotfiles substr($0, idx + length(placeholder))
        found = 1
      }
      print
    }
    END {
      if (!found) {
        print "restore: codex config template is missing {{DOTFILES_DIR}}" > "/dev/stderr"
        exit 1
      }
    }
  ' "$src" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

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
link claude/statusline.sh .claude/statusline.sh
link claude/CLAUDE.md .claude/CLAUDE.md

# ── Codex ─────────────────────────────────────────────────────────────────
render_codex_config codex/config.toml .codex/config.toml
link claude/CLAUDE.md .codex/AGENTS.md

log "Done."

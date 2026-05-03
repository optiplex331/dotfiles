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

# The old pre-Trellis rule/agent directories were linked as whole dirs on some
# machines. Remove only symlinks, preserving real user-managed directories.
unlink_obsolete .claude/rules
unlink_obsolete .claude/agents
unlink_obsolete .codex/rules
unlink_obsolete .codex/agents

unlink_obsolete .claude/rules/architecture.md
unlink_obsolete .claude/rules/code-review.md
unlink_obsolete .claude/rules/delegation.md
unlink_obsolete .claude/rules/documentation.md
unlink_obsolete .claude/rules/english.md
unlink_obsolete .claude/rules/planning.md
unlink_obsolete .claude/rules/testing.md
unlink_obsolete .codex/rules/architecture.md
unlink_obsolete .codex/rules/code-review.md
unlink_obsolete .codex/rules/delegation.md
unlink_obsolete .codex/rules/documentation.md
unlink_obsolete .codex/rules/english.md
unlink_obsolete .codex/rules/planning.md
unlink_obsolete .codex/rules/testing.md

# Trellis global source and Claude platform assets. Project-local hooks and
# settings remain repo-local; do not install them globally from dotfiles.
link .trellis .trellis
link .claude/agents/trellis-check.md .claude/agents/trellis-check.md
link .claude/agents/trellis-implement.md .claude/agents/trellis-implement.md
link .claude/agents/trellis-research.md .claude/agents/trellis-research.md
link .claude/commands/trellis .claude/commands/trellis
link .claude/skills/trellis-before-dev .claude/skills/trellis-before-dev
link .claude/skills/trellis-brainstorm .claude/skills/trellis-brainstorm
link .claude/skills/trellis-break-loop .claude/skills/trellis-break-loop
link .claude/skills/trellis-check .claude/skills/trellis-check
link .claude/skills/trellis-meta .claude/skills/trellis-meta
link .claude/skills/trellis-update-spec .claude/skills/trellis-update-spec

# ── Codex ─────────────────────────────────────────────────────────────────
render_codex_config codex/config.toml .codex/config.toml
link codex/AGENTS.md .codex/AGENTS.md
link .codex/agents/trellis-check.toml .codex/agents/trellis-check.toml
link .codex/agents/trellis-implement.toml .codex/agents/trellis-implement.toml
link .codex/agents/trellis-research.toml .codex/agents/trellis-research.toml

# Shared Trellis skills for Codex and other .agents/skills-compatible tools.
link .agents/skills/trellis-before-dev .agents/skills/trellis-before-dev
link .agents/skills/trellis-brainstorm .agents/skills/trellis-brainstorm
link .agents/skills/trellis-break-loop .agents/skills/trellis-break-loop
link .agents/skills/trellis-check .agents/skills/trellis-check
link .agents/skills/trellis-continue .agents/skills/trellis-continue
link .agents/skills/trellis-finish-work .agents/skills/trellis-finish-work
link .agents/skills/trellis-meta .agents/skills/trellis-meta
link .agents/skills/trellis-update-spec .agents/skills/trellis-update-spec

log "Done."

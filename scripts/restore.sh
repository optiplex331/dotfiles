#!/usr/bin/env bash
# Create managed symlinks from this repository to $HOME.
# Existing files and unmanaged symlinks are backed up before replacement.

set -Eeuo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"
DRY_RUN="${DRY_RUN:-0}"
BACKUP_DIR=''

log()  { printf '\033[0;32m[restore]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[restore]\033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m[restore]\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$DRY_RUN" == 0 || "$DRY_RUN" == 1 ]] || die "DRY_RUN must be 0 or 1"

run() {
  if [[ "$DRY_RUN" == 1 ]]; then
    printf '[restore][dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup_existing() {
  local dst="$1"
  local backup

  if [[ "$DRY_RUN" == 1 ]]; then
    warn "Would back up: $dst"
    return
  fi

  if [[ -z "$BACKUP_DIR" ]]; then
    mkdir -p "$HOME/.dotfiles_backup"
    BACKUP_DIR="$(mktemp -d "$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S).XXXXXX")"
  fi

  backup="$BACKUP_DIR/${dst#"$HOME"/}"
  mkdir -p "$(dirname "$backup")"
  warn "Backing up: $dst -> $backup"
  mv "$dst" "$backup"
}

# Symlink helper: link a repository-relative source to a home-relative target.
link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir
  local target
  dir="$(dirname "$dst")"

  if [[ ! -e "$src" ]]; then
    if [[ "$DRY_RUN" != 1 || "$src" != "$DOTFILES/codex/config.local.toml" || ! -f "$DOTFILES/codex/config.toml" ]]; then
      die "missing source: $src"
    fi
  fi

  if [[ ! -d "$dir" ]]; then
    run mkdir -p "$dir"
  fi

  if [[ -L "$dst" ]]; then
    target="$(readlink "$dst")"
    if [[ "$target" == "$src" ]]; then
      log "already linked: $dst"
      return
    fi
    backup_existing "$dst"
  elif [[ -e "$dst" ]]; then
    backup_existing "$dst"
  fi

  run ln -s "$src" "$dst"
  log "linked: $dst"
}

unlink_obsolete() {
  local dst="$HOME/$1"
  local target

  [[ -L "$dst" ]] || return 0
  target="$(readlink "$dst")"

  case "$target" in
    "$DOTFILES"/*)
      run rm -f "$dst"
      if [[ "$DRY_RUN" == 1 ]]; then
        log "would remove obsolete repository link: $dst"
      else
        log "removed obsolete repository link: $dst"
      fi
      ;;
    *)
      warn "Leaving unmanaged symlink: $dst -> $target"
      ;;
  esac
}

ensure_private_codex_config() {
  local config="$DOTFILES/codex/config.local.toml"
  local template="$DOTFILES/codex/config.toml"

  [[ -f "$template" ]] || die "missing Codex config template: $template"
  git -C "$DOTFILES" check-ignore -q -- codex/config.local.toml || die "codex/config.local.toml must be gitignored"

  if [[ -L "$config" ]]; then
    die "Codex local config must be a regular file: $config"
  fi

  if [[ ! -e "$config" ]]; then
    run cp "$template" "$config"
    run chmod 600 "$config"
    log "initialized private Codex config: $config"
  elif [[ "$DRY_RUN" != 1 ]]; then
    chmod 600 "$config"
  fi
}

# ── Shell ──────────────────────────────────────────────────────────────────
unlink_obsolete .zprofile
link zsh/.zshrc         .zshrc

# ── Editors ────────────────────────────────────────────────────────────────
link vim/vimrc         .vimrc
link nvim              .config/nvim

# ── Terminal ───────────────────────────────────────────────────────────────
link kitty             .config/kitty
link ghostty           .config/ghostty
link tmux/tmux.conf.local .tmux.conf.local

# ── Git ────────────────────────────────────────────────────────────────────
link git/gitconfig     .gitconfig
link git/ignore        .config/git/ignore

# ── Prompt ─────────────────────────────────────────────────────────────────
link starship/starship.toml .config/starship.toml

# ── Tools ──────────────────────────────────────────────────────────────────
link lazygit           .config/lazygit
link yazi              .config/yazi
link lazydocker/config.yml "Library/Application Support/lazydocker/config.yml"

# ── Obsolete Cursor config ─────────────────────────────────────────────────
unlink_obsolete "Library/Application Support/Cursor/User/settings.json"
unlink_obsolete "Library/Application Support/Cursor/User/keybindings.json"

# ── VS Code ────────────────────────────────────────────────────────────────
link vscode/settings.json    "Library/Application Support/Code/User/settings.json"
link vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"

# ── Claude Code ────────────────────────────────────────────────────────────
link claude/statusline.sh .claude/statusline.sh
link agents/AGENTS.md .claude/CLAUDE.md
unlink_obsolete .claude/agents
unlink_obsolete .claude/rules

# ── Codex ──────────────────────────────────────────────────────────────────
unlink_obsolete .Codex/statusline.sh
unlink_obsolete .Codex/AGENTS.md
unlink_obsolete .codex/agents
unlink_obsolete .codex/rules
ensure_private_codex_config
link codex/config.local.toml .codex/config.toml
link agents/AGENTS.md .codex/AGENTS.md

# ── Gemini CLI ────────────────────────────────────────────────────────────
link agents/AGENTS.md .gemini/GEMINI.md

log "Done."

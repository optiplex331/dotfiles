#!/usr/bin/env bash
# Bootstrap a new macOS machine:
#   1. Check / generate SSH key for GitHub
#   2. Install Homebrew
#   3. Clone dotfiles repo
#   4. Run restore.sh

set -Eeuo pipefail

REPO="git@github.com:optiplex331/dotfiles.git"
DOTFILES="$HOME/Code/dotfiles"

log()  { printf '\033[0;32m[setup]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[setup]\033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m[setup]\033[0m %s\n' "$*" >&2; exit 1; }

# ── SSH ────────────────────────────────────────────────────────────────────
if ! ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
  if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    log "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    log "Add this public key to GitHub: https://github.com/settings/keys"
    cat "$HOME/.ssh/id_ed25519.pub"
    read -rp "Press Enter after adding the key to GitHub..."
  else
    warn "SSH key exists but GitHub auth failed. Check ~/.ssh/id_ed25519.pub is added to GitHub."
    read -rp "Press Enter to continue..."
  fi
fi

# ── Homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# ── Clone dotfiles ─────────────────────────────────────────────────────────
if [ ! -d "$DOTFILES" ]; then
  log "Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILES")"
  git clone "$REPO" "$DOTFILES"
else
  log "Dotfiles already at $DOTFILES"
fi

# ── Restore ────────────────────────────────────────────────────────────────
log "Running restore..."
bash "$DOTFILES/scripts/restore.sh"

# ── Homebrew Bundle ────────────────────────────────────────────────────────
if [ -f "$DOTFILES/Brewfile" ]; then
  log "Installing Homebrew packages..."
  brew bundle --file="$DOTFILES/Brewfile"
fi

log "Setup complete. Restart your terminal."

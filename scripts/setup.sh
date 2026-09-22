#!/usr/bin/env bash
# Bootstrap a new macOS machine:
#   1. Verify GitHub SSH access
#   2. Install Homebrew if needed
#   3. Clone or validate the dotfiles repository
#   4. Restore links
#   5. Install Homebrew packages

set -Eeuo pipefail

REPO="git@github.com:optiplex331/dotfiles.git"
DOTFILES="${DOTFILES:-$HOME/Projects/dotfiles}"

log()  { printf '\033[0;32m[setup]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[setup]\033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m[setup]\033[0m %s\n' "$*" >&2; exit 1; }

github_ssh_check() {
  local output

  output="$(ssh -T git@github.com 2>&1)" || true
  [[ -n "$output" ]] && printf '%s\n' "$output"
  [[ "$output" == *"successfully authenticated"* ]]
}

# GitHub prints a successful authentication message but intentionally returns
# status 1 because it does not provide shell access. Check the message instead.
if ! github_ssh_check; then
  if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
    log "Generating SSH key..."
    mkdir -p "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    log "Add this public key to GitHub: https://github.com/settings/keys"
    cat "$HOME/.ssh/id_ed25519.pub"
    read -rp "Press Enter after adding the key to GitHub..."
  else
    warn "SSH key exists but GitHub auth failed. Check ~/.ssh/id_ed25519.pub is added to GitHub."
    read -rp "Press Enter after fixing the GitHub SSH key..."
  fi

  github_ssh_check || die "GitHub SSH authentication still failed."
fi

# ── Homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_BIN="$(command -v brew || true)"
if [[ -z "$BREW_BIN" ]]; then
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      BREW_BIN="$candidate"
      break
    fi
  done
fi
[[ -n "$BREW_BIN" ]] || die "Homebrew installed but brew was not found in PATH or a standard prefix."
eval "$("$BREW_BIN" shellenv)"

# ── Clone or validate dotfiles ─────────────────────────────────────────────
if [[ -e "$DOTFILES" || -L "$DOTFILES" ]]; then
  [[ -d "$DOTFILES" ]] || die "DOTFILES exists but is not a directory: $DOTFILES"
  git -C "$DOTFILES" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "DOTFILES is not a Git repository: $DOTFILES"
  repo_root="$(git -C "$DOTFILES" rev-parse --show-toplevel)"
  dotfiles_root="$(cd "$DOTFILES" && pwd -P)"
  [[ "$repo_root" == "$dotfiles_root" ]] || die "DOTFILES points inside another Git repository: $DOTFILES"
  [[ -f "$DOTFILES/scripts/restore.sh" && -f "$DOTFILES/Brewfile" ]] || die "DOTFILES is missing required setup files: $DOTFILES"
  log "Using existing dotfiles repository at $DOTFILES"
else
  log "Cloning dotfiles..."
  mkdir -p "$(dirname "$DOTFILES")"
  git clone "$REPO" "$DOTFILES"
fi

# ── Restore ────────────────────────────────────────────────────────────────
log "Running restore..."
bash "$DOTFILES/scripts/restore.sh"

# ── Homebrew Bundle ────────────────────────────────────────────────────────
if [[ -f "$DOTFILES/Brewfile" ]]; then
  log "Installing Homebrew packages..."
  brew bundle --file="$DOTFILES/Brewfile"
fi

log "Setup complete. Restart your terminal."

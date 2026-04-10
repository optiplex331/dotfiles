#!/usr/bin/env bash
# Bootstrap dotfiles: create symlinks from $HOME to this repo.
# Usage: bash setup.sh

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"
  local dir
  dir="$(dirname "$dst")"
  mkdir -p "$dir"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up: $dst -> $dst.backup"
    mv "$dst" "$dst.backup"
  fi
  ln -sfn "$src" "$dst"
  echo "linked: $dst"
}

# Home directory dotfiles
link .zshrc             .zshrc
link .vimrc             .vimrc
link .tmux.conf.local   .tmux.conf.local

# ~/.config entries
link config/kitty        .config/kitty
link config/lazygit      .config/lazygit
link config/nvim         .config/nvim
link config/starship.toml .config/starship.toml
link config/yazi         .config/yazi

# Library/Application Support
link "Library/Application Support/Cursor/User/settings.json"    "Library/Application Support/Cursor/User/settings.json"
link "Library/Application Support/Cursor/User/keybindings.json" "Library/Application Support/Cursor/User/keybindings.json"
link "Library/Application Support/lazydocker/config.yml"        "Library/Application Support/lazydocker/config.yml"

echo "Done."

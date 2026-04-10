# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Install

```bash
brew install chezmoi

git clone git@github.com:optiplex331/dotfiles.git ~/Code/dotfiles

mkdir -p ~/.config/chezmoi
echo 'sourceDir = "/Users/$USER/Code/dotfiles"' > ~/.config/chezmoi/chezmoi.toml

chezmoi apply
```

## Daily Usage

```bash
# Edit a dotfile (opens in $EDITOR, auto-updates source)
chezmoi edit ~/.zshrc

# Preview pending changes
chezmoi diff

# Apply changes from source to home
chezmoi apply

# Check which files chezmoi manages
chezmoi managed
```

## Source Layout

Files in this repo mirror the home directory structure using chezmoi naming conventions:

| Source path | Target path |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_vimrc` | `~/.vimrc` |
| `dot_tmux.conf.local` | `~/.tmux.conf.local` |
| `dot_config/kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `dot_config/nvim/` | `~/.config/nvim/` |
| `dot_config/yazi/` | `~/.config/yazi/` |
| `dot_config/starship.toml` | `~/.config/starship.toml` |
| `dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` |
| `Library/Application Support/Cursor/User/` | `~/Library/Application Support/Cursor/User/` |
| `Library/Application Support/lazydocker/` | `~/Library/Application Support/lazydocker/` |

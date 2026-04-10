# dotfiles

Personal macOS development environment configuration managed with symlinks.

## Structure

| Directory | Target | Description |
|-----------|--------|-------------|
| `zsh/` | `~/.zshrc` | Zsh shell configuration |
| `vim/` | `~/.vimrc` | Vim configuration |
| `nvim/` | `~/.config/nvim` | Neovim (LazyVim) |
| `kitty/` | `~/.config/kitty` | Kitty terminal emulator |
| `tmux/` | `~/.tmux.conf.local` | Tmux configuration |
| `git/` | `~/.gitconfig`, `~/.config/git/ignore` | Git configuration |
| `starship/` | `~/.config/starship.toml` | Starship prompt |
| `lazygit/` | `~/.config/lazygit` | Lazygit configuration |
| `lazydocker/` | `~/Library/Application Support/lazydocker` | Lazydocker configuration |
| `yazi/` | `~/.config/yazi` | Yazi file manager |
| `cursor/` | `~/Library/Application Support/Cursor/User` | Cursor editor settings |

## Install

On a fresh macOS machine:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/optiplex331/dotfiles/main/scripts/setup.sh)"
```

On an existing machine with the repo already cloned:

```bash
bash ~/Code/dotfiles/scripts/restore.sh
```

## Tools

- **Shell:** Zsh + [Starship](https://starship.rs) prompt + [zoxide](https://github.com/ajeetdsouza/zoxide)
- **Terminal:** [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Multiplexer:** [Tmux](https://github.com/tmux/tmux)
- **Editor:** [Neovim](https://neovim.io) (LazyVim) + [Cursor](https://cursor.sh)
- **Git UI:** [Lazygit](https://github.com/jesseduffield/lazygit)
- **File Manager:** [Yazi](https://github.com/sxyazi/yazi)
- **Docker UI:** [Lazydocker](https://github.com/jesseduffield/lazydocker)

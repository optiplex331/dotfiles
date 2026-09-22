#!/usr/bin/env bash
# Read-only checks for the managed dotfiles links and local agent environment.

set -u

DOTFILES="$(cd "$(dirname "$0")/.." && pwd -P)"
failures=0
warnings=0

pass() { printf '\033[0;32m[doctor:ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[doctor:warn]\033[0m %s\n' "$*"; warnings=$((warnings + 1)); }
fail() { printf '\033[0;31m[doctor:fail]\033[0m %s\n' "$*" >&2; failures=$((failures + 1)); }

check_link() {
  local source="$DOTFILES/$1"
  local destination="$HOME/$2"
  local actual

  if [[ ! -L "$destination" ]]; then
    fail "missing managed symlink: $destination"
    return
  fi

  actual="$(readlink "$destination")"
  if [[ "$actual" != "$source" ]]; then
    fail "wrong target: $destination -> $actual"
  elif [[ ! -e "$destination" ]]; then
    fail "broken symlink: $destination"
  else
    pass "$destination"
  fi
}

check_link zsh/.zshrc .zshrc
check_link vim/vimrc .vimrc
check_link nvim .config/nvim
check_link kitty .config/kitty
check_link ghostty .config/ghostty
check_link tmux/tmux.conf.local .tmux.conf.local
check_link git/gitconfig .gitconfig
check_link git/ignore .config/git/ignore
check_link starship/starship.toml .config/starship.toml
check_link lazygit .config/lazygit
check_link yazi .config/yazi
check_link lazydocker/config.yml "Library/Application Support/lazydocker/config.yml"
check_link vscode/settings.json "Library/Application Support/Code/User/settings.json"
check_link vscode/keybindings.json "Library/Application Support/Code/User/keybindings.json"
check_link claude/statusline.sh .claude/statusline.sh
check_link agents/AGENTS.md .claude/CLAUDE.md
check_link codex/config.local.toml .codex/config.toml
check_link agents/AGENTS.md .codex/AGENTS.md
check_link agents/AGENTS.md .gemini/GEMINI.md

if [[ -f "$DOTFILES/codex/config.local.toml" && ! -L "$DOTFILES/codex/config.local.toml" ]]; then
  if git -C "$DOTFILES" check-ignore -q -- codex/config.local.toml; then
    pass "Codex runtime config is gitignored"
  else
    fail "Codex runtime config is not gitignored"
  fi

  if command -v python3 >/dev/null 2>&1 && python3 -c 'import tomllib' >/dev/null 2>&1; then
    if python3 -c 'import pathlib,sys,tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' "$DOTFILES/codex/config.local.toml" >/dev/null 2>&1; then
      pass "Codex runtime config parses as TOML"
    else
      fail "Codex runtime config is invalid TOML"
    fi
  else
    warn "Python 3.11+ is unavailable; skipped TOML parsing"
  fi
else
  fail "Codex runtime config is missing or is not a regular file"
fi

for tool in git zsh brew claude codex; do
  if command -v "$tool" >/dev/null 2>&1; then
    pass "$tool is available"
  else
    warn "$tool is not on PATH"
  fi
done

if command -v gemini >/dev/null 2>&1; then
  pass "gemini is available"
else
  warn "gemini CLI is not on PATH; Gemini context loading cannot be checked"
fi

if command -v macism >/dev/null 2>&1; then
  pass "macism is available"
else
  warn "macism is not on PATH; Neovim input-method switching is disabled"
fi

if [[ -s "$DOTFILES/nvim/lazy-lock.json" ]]; then
  pass "Neovim plugin lockfile is present"
else
  fail "Neovim plugin lockfile is missing or empty"
fi

if command -v brew >/dev/null 2>&1; then
  if output="$(HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --verbose --file="$DOTFILES/Brewfile" 2>&1)"; then
    pass "Brewfile dependencies are satisfied"
  else
    warn "Brewfile has unmet dependencies:"
    printf '%s\n' "$output"
  fi
fi

printf '\n[doctor] %d failure(s), %d warning(s)\n' "$failures" "$warnings"
[[ "$failures" -eq 0 ]]

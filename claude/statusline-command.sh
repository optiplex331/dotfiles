#!/usr/bin/env bash
# Claude Code status line — mirrors your Starship prompt style
# Receives JSON on stdin from Claude Code

input=$(cat)

# ── Directory ────────────────────────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
[ -z "$cwd" ] && cwd=$(pwd)

# Replace $HOME with ~
home="$HOME"
display_dir="${cwd/#$home/~}"

# ── Git branch & status ──────────────────────────────────────────────────────
git_part=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # Collect status indicators (mirrors your starship git_status config)
    status_str=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
    indicators=""
    modified=$(echo "$status_str" | grep -c '^ M\| M' 2>/dev/null || true)
    untracked=$(echo "$status_str" | grep -c '^??' 2>/dev/null || true)
    staged=$(echo "$status_str" | grep -c '^[MADRCU]' 2>/dev/null || true)
    [ "$modified" -gt 0 ] 2>/dev/null && indicators="${indicators}!${modified}"
    [ "$untracked" -gt 0 ] 2>/dev/null && indicators="${indicators}?${untracked}"
    [ "$staged" -gt 0 ] 2>/dev/null && indicators="${indicators}+${staged}"
    if [ -n "$indicators" ]; then
      git_part=" $branch [$indicators]"
    else
      git_part=" $branch"
    fi
  fi
fi

# ── Claude model ─────────────────────────────────────────────────────────────
model_raw=$(echo "$input" | jq -r '.model.display_name // ""')
# Ensure the name starts with "Claude "
case "$model_raw" in
  Claude\ *) model="$model_raw" ;;
  *) [ -n "$model_raw" ] && model="Claude $model_raw" || model="" ;;
esac

# ── ANSI colors ───────────────────────────────────────────────────────────────
BLUE=$'\033[94m'
CYAN=$'\033[96m'
GREEN=$'\033[92m'
YELLOW=$'\033[93m'
MAGENTA=$'\033[95m'
WHITE=$'\033[97m'
DIM=$'\033[2m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

# ── Helper: build a progress bar ─────────────────────────────────────────────
# Usage: make_bar <percentage> <width>
# Outputs a bar string like ●●●●●·····
make_bar() {
  local pct="$1"
  local width="$2"
  local filled empty bar i
  filled=$(printf '%.0f' "$(echo "$pct $width" | awk '{printf "%.0f", $1 * $2 / 100}')")
  [ "$filled" -gt "$width" ] && filled=$width
  empty=$(( width - filled ))
  bar=""
  for i in $(seq 1 "$filled"); do bar="${bar}●"; done
  for i in $(seq 1 "$empty");  do bar="${bar}·"; done
  printf '%s' "$bar"
}

# ── Context usage progress bar ───────────────────────────────────────────────
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_part=""
if [ -n "$used_pct" ]; then
  bar=$(make_bar "$used_pct" 10)
  context_part="ctx [${bar}] $(printf '%.0f' "$used_pct")%"
fi

# ── Helper: format an age in seconds as a ↺ refresh indicator ────────────────
# Usage: format_age <seconds>
# Outputs e.g. ↺45m  ↺2h  ↺1h30m  ↺1d  ↺2d14h
format_age() {
  local age="$1"
  [ "$age" -lt 0 ] && age=0
  local age_d=$(( age / 86400 ))
  local age_h=$(( (age % 86400) / 3600 ))
  local age_m=$(( (age % 3600) / 60 ))
  if [ "$age_d" -ge 1 ] && [ "$age_h" -eq 0 ]; then
    printf '↺%sd' "$age_d"
  elif [ "$age_d" -ge 1 ]; then
    printf '↺%sd%sh' "$age_d" "$age_h"
  elif [ "$age_h" -ge 1 ] && [ "$age_m" -eq 0 ]; then
    printf '↺%sh' "$age_h"
  elif [ "$age_h" -ge 1 ]; then
    printf '↺%sh%sm' "$age_h" "$age_m"
  else
    printf '↺%sm' "$age_m"
  fi
}

# ── Rate limit quota bars ─────────────────────────────────────────────────────
quota_part=""
five_pct=$(echo "$input"  | jq -r '.rate_limits.five_hour.used_percentage  // empty')
week_pct=$(echo "$input"  | jq -r '.rate_limits.seven_day.used_percentage  // empty')
five_resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_resets_at=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
now=$(date +%s)

DIM_RESET=$'\033[22m'   # cancel dim, restore normal intensity (keeps current color)
if [ -n "$five_pct" ]; then
  bar=$(make_bar "$five_pct" 8)
  five_refresh=""
  if [ -n "$five_resets_at" ] && [ "$five_resets_at" != "null" ]; then
    five_age=$(( now - (five_resets_at - 18000) ))
    five_refresh=" ${DIM}$(format_age "$five_age")${DIM_RESET}"
  fi
  quota_part="${quota_part}5h [${bar}] $(printf '%.0f' "$five_pct")%${five_refresh}"
fi
if [ -n "$week_pct" ]; then
  bar=$(make_bar "$week_pct" 8)
  week_refresh=""
  if [ -n "$week_resets_at" ] && [ "$week_resets_at" != "null" ]; then
    week_age=$(( now - (week_resets_at - 604800) ))
    week_refresh=" ${DIM}$(format_age "$week_age")${DIM_RESET}"
  fi
  [ -n "$quota_part" ] && quota_part="${quota_part}  "
  quota_part="${quota_part}7d [${bar}] $(printf '%.0f' "$week_pct")%${week_refresh}"
fi

printf '%s' "${BOLD}${BLUE}${display_dir}${RESET}"
if [ -n "$git_part" ]; then
  printf '%s' " ${CYAN}${git_part}${RESET}"
fi
if [ -n "$model" ]; then
  printf '%s' "  ${MAGENTA}${model}${RESET}"
fi
if [ -n "$context_part" ]; then
  printf '%s' "  ${WHITE}${context_part}${RESET}"
fi
if [ -n "$quota_part" ]; then
  printf '%s' "  ${YELLOW}${quota_part}${RESET}"
fi
printf '\n'

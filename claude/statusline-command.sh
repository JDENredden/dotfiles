#!/bin/bash
# Claude Code statusLine — Catppuccin Mocha, Tide/Starship lean aesthetic

input=$(cat)

# --- Extract JSON fields ---
cwd=$(echo "$input"        | jq -r '.workspace.current_dir // .cwd // "~"')
model=$(echo "$input"      | jq -r '.model.display_name // "Claude"')
used_pct=$(echo "$input"   | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input"   | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input"  | jq -r '.context_window.total_output_tokens // empty')
vim_mode=$(echo "$input"   | jq -r '.vim.mode // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')

# --- Shorten home to ~ ---
short_cwd="${cwd/#$HOME/\~}"

# --- Catppuccin Mocha palette (true-colour) ---
TEXT=$'\e[38;2;205;214;244m'       # cdd6f4
BLUE=$'\e[38;2;137;180;250m'       # 89b4fa
YELLOW=$'\e[38;2;249;226;175m'     # f9e2af
GREEN=$'\e[38;2;166;227;161m'      # a6e3a1
RED=$'\e[38;2;243;139;168m'        # f38ba8
ORANGE=$'\e[38;2;250;179;135m'     # fab387
CYAN=$'\e[38;2;148;226;213m'       # 94e2d5
DIM=$'\e[2m'
RESET=$'\e[0m'

# Separator used between segments
SEP=" ${DIM}·${RESET} "

# --- Directory segment (yellow, like Tide's pwd) ---
dir_seg="${YELLOW}${short_cwd}${RESET}"

# --- Git segment (run in cwd to get real repo info) ---
git_seg=""
if git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null); then
    # Branch name in blue
    git_seg="${SEP}${BLUE}${git_branch}${RESET}"
    # Quick dirty check — skip lock acquisition to stay non-blocking
    if ! git -C "$cwd" diff --quiet --ignore-submodules 2>/dev/null || \
       ! git -C "$cwd" diff --cached --quiet --ignore-submodules 2>/dev/null; then
        git_seg="${git_seg}${ORANGE}*${RESET}"
    fi
elif git -C "$cwd" rev-parse --git-dir &>/dev/null; then
    # Detached HEAD — show short hash
    hash=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    git_seg="${SEP}${ORANGE}detached:${hash}${RESET}"
fi

# --- Model segment (cyan, lean) ---
model_seg="${CYAN}${model}${RESET}"

# --- Context usage — green → yellow → red based on used % ---
ctx_seg=""
if [ -n "$used_pct" ]; then
    pct_int=$(printf "%.0f" "$used_pct")
    remaining=$((100 - pct_int))
    if   [ "$pct_int" -ge 80 ]; then ctx_color="$RED"
    elif [ "$pct_int" -ge 50 ]; then ctx_color="$YELLOW"
    else                              ctx_color="$GREEN"
    fi
    ctx_seg="${SEP}${ctx_color}ctx ${remaining}%${RESET}"
fi

# --- Session token total (compact: 12k, 1.4M) ---
usage_seg=""
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
    total=$(( total_in + total_out ))
    if   [ "$total" -ge 1000000 ]; then
        formatted="$(awk "BEGIN { printf \"%.1fM\", $total/1000000 }")"
    elif [ "$total" -ge 1000 ]; then
        formatted="$(awk "BEGIN { printf \"%.0fk\", $total/1000 }")"
    else
        formatted="$total"
    fi
    usage_seg="${SEP}${DIM}${formatted} tok${RESET}"
fi

# --- Vim mode ---
vim_seg=""
if [ -n "$vim_mode" ]; then
    if [ "$vim_mode" = "NORMAL" ]; then
        vim_seg="${SEP}${YELLOW}NORMAL${RESET}"
    else
        vim_seg="${SEP}${GREEN}INSERT${RESET}"
    fi
fi

# --- Session name ---
session_seg=""
if [ -n "$session_name" ]; then
    session_seg="${SEP}${DIM}${session_name}${RESET}"
fi

# --- Assemble lines ---
# Line 1: ╭─ <dir> <git>
# Line 2: ╰─ <model> <ctx> <tokens> <vim> <session>
line1="${dir_seg}${git_seg}"
line2="${model_seg}${ctx_seg}${usage_seg}${vim_seg}${session_seg}"

printf "╭─ %s\n╰─ %s\n" "$line1" "$line2"

#!/bin/bash
# Claude Code status line: model | directory (git branch) | context tokens used
# Reads the JSON payload Claude Code sends on stdin.

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
[ -z "$model" ] && model="Claude"

dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
if [ -n "$dir" ]; then
  dir_display=$(basename "$dir" 2>/dev/null)
  [ -z "$dir_display" ] && dir_display="$dir"
else
  dir_display="?"
fi

# Best-effort git branch, skip optional locks so we never block/write lock files.
branch=""
if [ -n "$dir" ] && [ -d "$dir" ]; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
fi

transcript=$(echo "$input" | jq -r '.transcript_path // empty' 2>/dev/null)

tokens="?"
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  # Grab the usage object from the most recent assistant message in the transcript.
  usage_json=$(jq -c 'select(.type == "assistant" and .message.usage != null) | .message.usage' "$transcript" 2>/dev/null | tail -1)
  if [ -n "$usage_json" ]; then
    tokens_num=$(echo "$usage_json" | jq -r '((.input_tokens // 0) + (.cache_read_input_tokens // 0) + (.cache_creation_input_tokens // 0))' 2>/dev/null)
    if echo "$tokens_num" | grep -Eq '^[0-9]+$'; then
      if [ "$tokens_num" -ge 1000 ]; then
        tokens=$(awk -v t="$tokens_num" 'BEGIN{printf "%.1fk", t/1000}')
      else
        tokens="$tokens_num"
      fi
    fi
  fi
fi

# Claude brand color (terracotta), truecolor ANSI. Reset after each colored segment.
claude_color='\033[38;2;218;119;86m'
reset='\033[0m'

if [ -n "$branch" ]; then
  printf "${claude_color}%s${reset} | %s (%s) | ${claude_color}%s tokens${reset}" "$model" "$dir_display" "$branch" "$tokens"
else
  printf "${claude_color}%s${reset} | %s | ${claude_color}%s tokens${reset}" "$model" "$dir_display" "$tokens"
fi

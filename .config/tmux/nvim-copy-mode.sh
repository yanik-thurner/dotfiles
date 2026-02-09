#!/usr/bin/env bash
set -eo pipefail

file=$(mktemp --suffix=.tmux-copy)
hash=$(head -c8 /dev/urandom | od -An -tx1 | tr -d ' \n')
sock="/tmp/nvim-copy-${hash}.sock"
ready="/tmp/nvim-copy-${hash}.ready"

cleanup() { rm -f "$file" "$sock" "$ready"; }
trap cleanup EXIT

tmux capture-pane -J -e -p -S - -E - > "$file"

cursor_y=$(tmux display -p '#{cursor_y}')
hist=$(tmux display -p '#{history_size}')
line=$((hist + cursor_y + 1))
col=$(tmux display -p '#{cursor_x}')
pane_w=$(tmux display -p '#{pane_width}')
pane_h=$(tmux display -p '#{pane_height}')

COPY_LINE="$line" COPY_COL="$col" COPY_FILE="$file" COPY_READY="$ready" COPY_W="$pane_w" COPY_H="$pane_h" \
  nvim --headless --listen "$sock" -u ~/.config/nvim/copy-mode.lua &
pid=$!

elapsed=0
while [ ! -e "$ready" ] && [ "$elapsed" -lt 3000 ]; do
  sleep 0.01
  elapsed=$((elapsed + 10))
done

if [ ! -e "$ready" ]; then
  kill "$pid" 2>/dev/null || true
  exit 1
fi

tmux popup -E -B -x P -y P -w "$pane_w" -h "$pane_h" \
  nvim --server "$sock" --remote-ui

kill "$pid" 2>/dev/null || true

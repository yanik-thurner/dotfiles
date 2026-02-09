#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh

file=$(mktemp --suffix=.tmux-copy)

cursor_y=$(tmux display -p '#{cursor_y}')
line=$(($(tmux display -p '#{history_size}') + cursor_y + 1))
col=$(($(tmux display -p '#{cursor_x}') + 1))
pane_w=$(tmux display -p '#{pane_width}')
pane_h=$(tmux display -p '#{pane_height}')

total=$(wc -l < "$file")

tmux capture-pane -e -p -S - -E - > "$file"

echo "cursor_y=$cursor_y history=$( tmux display -p '#{history_size}') line=$line col=$col" > /tmp/copy-mode-debug.txt

tmux popup -E -B -x P -y P -w "$pane_w" -h "$pane_h" \
  env COPY_LINE="$line" COPY_COL="$col" COPY_FILE="$file" \
  nvim -u ~/.config/nvim/copy-mode.lua --cmd 'set lazyredraw'

rm -f "$file"

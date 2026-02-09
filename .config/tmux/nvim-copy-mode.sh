#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh

file=$(mktemp --suffix=.tmux-copy)

cursor_y=$(tmux display -p '#{cursor_y}')
line=$(($(tmux display -p '#{history_size}') + cursor_y + 1))
col=$(($(tmux display -p '#{cursor_x}')))
pane_w=$(tmux display -p '#{pane_width}')
pane_h=$(tmux display -p '#{pane_height}')

tmux capture-pane -e -p -S - -E - > "$file"
total=$(wc -l < "$file")

tmux popup -E -B -x P -y P -w "$pane_w" -h "$pane_h" \
  env COPY_LINE="$line" COPY_COL="$col" COPY_FILE="$file" COPY_TOTAL="$total" \
  nvim -u ~/.config/nvim/copy-mode.lua --cmd 'set lazyredraw'

rm -f "$file"

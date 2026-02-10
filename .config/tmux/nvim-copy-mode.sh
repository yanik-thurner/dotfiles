#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh

file=$(mktemp --suffix=.tmux-copy)

read -r cy hs cx pw ph <<< "$(tmux display -p '#{cursor_y} #{history_size} #{cursor_x} #{pane_width} #{pane_height}')"
line=$((hs + cy + 1))

tmux capture-pane -e -p -N -S - -E - > "$file"

tmux popup -s 'default' -E -B -x P -y P -w "$pw" -h "$ph" \
  env COPY_LINE="$line" COPY_COL="$cx" \
  nvim --clean --noplugin -u ~/.config/nvim/copy-mode.lua --cmd 'set lazyredraw' -R "$file"

rm -f "$file"

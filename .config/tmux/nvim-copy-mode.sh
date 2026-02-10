#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh

read -r pane_id cursor_x cursor_y history_size pane_width pane_height <<< "$(tmux display -p '#{pane_id} #{cursor_x} #{cursor_y} #{history_size} #{pane_width} #{pane_height}')"

filename="/dev/shm/tmux-cap-$$"

tmux capture-pane -t "$pane_id" -p -e -J -S - -E - > "$filename"

echo "pane_id:$pane_id cursor_x:$cursor_x cursor_y:$cursor_y history_size:$history_size pane_width:$pane_width pane_height:$pane_height" > /tmp/copy-mode-debug.txt

exec tmux display-popup -xP -yP -w "$pane_width" -h "$pane_height" -E -B \
  env CURSOR_Y="$(( $history_size + $cursor_y + 1 ))" CURSOR_X="$cursor_x" COPY_FILE="$filename" \
  nvim --clean -u "~/.config/tmux/copy-mode.lua"

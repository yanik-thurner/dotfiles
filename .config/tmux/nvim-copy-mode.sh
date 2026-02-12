#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh
read -r pane_id cursor_x cursor_y history_size pane_width pane_height \
  <<< "$(tmux display -p '#{pane_id} #{cursor_x} #{cursor_y} #{history_size} #{pane_width} #{pane_height}')"

filename="/dev/shm/tmux-cap-$$"
helper="/dev/shm/tmux-helper-$$"
curtain_plain="/dev/shm/tmux-curtain-plain-$$"
curtain_color="/dev/shm/tmux-curtain-color-$$"

cleanup() { rm -f "$filename" "$helper" "$curtain_plain" "$curtain_color"; }
trap cleanup EXIT

printf '\e[?25l' > "$filename"
tmux capture-pane -t "$pane_id" -p -e -S - -E - >> "$filename"
tmux capture-pane -t "$pane_id" -p | head -n -1 > "$curtain_plain"
tmux capture-pane -t "$pane_id" -p -e | head -n -1 > "$curtain_color"

# Write helper script — no argument parsing, just cat + exec
cat > "$helper" << EOF
#!/bin/sh
cat $curtain_color
exec env CURSOR_Y=$cursor_y CURSOR_X=$cursor_x COPY_FILE=$filename HISTORY_SIZE=$history_size nvim --cmd 'set lazyredraw' --clean -u \$HOME/.config/tmux/copy-mode.lua $curtain_plain
EOF
chmod +x "$helper"

tmux display-popup -xP -yP -w "$pane_width" -h "$pane_height" -EE -B "cat $curtain_color; exec $helper"


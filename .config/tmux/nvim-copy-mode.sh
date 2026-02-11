#!/usr/bin/env bash
# ~/.config/tmux/scripts/nvim-copy-mode.sh
read -r pane_id cursor_x cursor_y history_size pane_width pane_height \
  <<< "$(tmux display -p '#{pane_id} #{cursor_x} #{cursor_y} #{history_size} #{pane_width} #{pane_height}')"

filename="/dev/shm/tmux-cap-$$"
tmux capture-pane -t "$pane_id" -p -e -N -S - -E - > "$filename"

exec $(tmux display-popup -xP -yP -w "$pane_width" -h "$pane_height" -E -B \
  /bin/sh -c '
    printf "\e[?25l"
    exec env \
      TERMINFO="$HOME/.config/tmux/terminfo" \
      CURSOR_Y="'"$cursor_y"'" \
      CURSOR_X="'"$cursor_x"'" \
      COPY_FILE="'"$filename"'" \
      HISTORY_SIZE="'"$history_size"'" \
      nvim --clean -u "$HOME/.config/tmux/copy-mode.lua"
  '; rm -f "$filename")

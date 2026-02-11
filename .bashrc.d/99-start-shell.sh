#!/bin/bash
SESSION="main"

has_tmux=$(command -v tmux &>/dev/null && echo true || echo false)
has_fish=$(command -v fish &>/dev/null && echo true || echo false)
has_nvim=$(command -v nvim &>/dev/null && echo true || echo false)
in_nvim=$([[ -n "$NVIM" ]] && echo true || echo false)
in_toolbox=$([[ -f /run/.toolboxenv ]] && echo true || echo false)
in_fish=$([[ -n "$FISH_VERSION" ]] && echo true || echo false)
parent_cmd=$(ps -o comm= -p "$PPID" 2>/dev/null)
in_fish=$([[ "$parent_cmd" == "fish" ]] && echo true || echo false)

session_info=$(tmux list-sessions -F '#{session_name} #{session_attached}' 2>/dev/null | grep "^$SESSION ")
session_exists=$([[ -n "$session_info" ]] && echo true || echo false)
session_used=$([[ -n "$session_info" && "$session_info" != *" 0" ]] && echo true || echo false)


shell_cmd=($([[ "$has_fish" == true && "$in_fish" == false ]] && echo fish || echo bash))

# some vars are not set in toolbox, so we just start the shell to avoid recursion
[[ "$in_toolbox" == true ]] && exec "${shell_cmd[@]}"

[[ "$has_tmux" == true && "$session_exists" == true && "$session_used" == false ]] && exec tmux attach-session -t "$SESSION"
[[ "$has_tmux" == true && "$session_exists" == false ]] && shell_cmd=(tmux new-session -s "$SESSION" "${shell_cmd[@]}")

# prevent bash loop, nothing else needs to start
[[ "${shell_cmd[*]}" == "bash" ]] && return
exec "${shell_cmd[@]}"

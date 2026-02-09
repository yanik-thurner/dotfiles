# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

load_bashrc () {
    if [ -d ~/.bashrc.d ]; then
        for rc in ~/.bashrc.d/*; do
            [ -f "$rc" ] && . "$rc"
        done
    fi
}

is_interactive=$([[ $- == *i* ]] && echo true || echo false)

if [[ "$is_interactive" == true ]]; then
    load_bashrc
fi

unset rc

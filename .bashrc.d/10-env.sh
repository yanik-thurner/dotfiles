#!/bin/bash

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

#=============#
#=== Cargo ===#
#=============#
. "$HOME/.cargo/env"

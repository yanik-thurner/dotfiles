alias bash='env NO_FISH=1 bash'

if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.bashrc.d/*-aliases.sh
    fish_vi_key_bindings
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /var/home/jay/.lmstudio/bin
# End of LM Studio CLI section


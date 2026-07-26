# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# --- personal additions (from ~/dotfiles) ---

# pel tooling + personal scripts on PATH
export PATH="/opt/pel/bin:$HOME/.local/share/scripts:$PATH"

# Ctrl-f -> tmux-sessionizer (fzf-based project switcher)
bind -x '"\C-f": tmux-sessionizer'

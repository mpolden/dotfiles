# -*- mode: sh -*-

if [[ -n "$SSH_TTY" && -z "$TMUX" && -z "$EMACS" && "$TERM" != "dumb" ]]; then
    (( $+commands[tmux] )) && tmux new-session -AD -s $USER
fi

# Local configuration
if [[ -s "$HOME/.zlogin.local" ]]; then
    source "$HOME/.zlogin.local"
fi

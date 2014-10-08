if [[ -n "$SSH_TTY" && -z "$TMUX" && "$TERM" != "dumb" ]]; then
    (( $+commands[tmux] )) && (tmux attach -d || tmux)
fi

# Local configuration
[[ -s "$HOME/.zlogin.local" ]] && source "$HOME/.zlogin.local"

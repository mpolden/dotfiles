if [[ -n "$SSH_TTY" ]]; then
    if [[ -z "$TMUX" ]]; then
        (( $+commands[tmux] )) && (tmux attach -d || tmux)
    fi
else
    (( $+commands[fortune] )) && fortune -a
fi

# Local configuration
[[ -s "$HOME/.zlogin.local" ]] && source "$HOME/.zlogin.local"

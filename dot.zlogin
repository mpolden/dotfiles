if [[ -n "$SSH_TTY" && -z "$TMUX" ]]; then
    (( $+commands[tmux] )) && (tmux attach -d || tmux)
fi

if [[ -n "$SSH_TTY" && -x "$(which tmux)" && -z "$TMUX" ]]; then
    tmux attach -d || tmux
fi

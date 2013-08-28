#!/usr/bin/env bash

IFS=$'\n'
for LINE in $(tmux list-windows | awk '{print $1,$2}' | tr -d ':'); do
    WIN=$(echo "$LINE" | cut -d ' ' -f 1) 
    CMD=$(echo "$LINE" | cut -d ' ' -f 2) 
    if [[ "$CMD" == zsh* ]]; then
        tmux send -t 0:${WIN}.0 'source ~/.zshrc' ENTER
    fi
done
unset IFS

exit $?

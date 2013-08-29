#!/usr/bin/env bash

for LINE in $(tmux list-panes -aF '#{session_name}:#{window_index}.#{pane_index},#{pane_pid}'); do
    PANE=$(echo "$LINE" | cut -d ',' -f 1)
    PANE_PID=$(echo "$LINE" | cut -d ',' -f 2)
    ps --no-headers -o pid --ppid=$PANE_PID > /dev/null
    if [[ $? -ne 0 ]]; then
        tmux send-keys -t $PANE 'source ~/.zshrc' enter
    fi
done

exit $?

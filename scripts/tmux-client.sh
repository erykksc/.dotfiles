#!/bin/zsh

# Start home directory tmux session if it doesn't exist
output=$(/opt/homebrew/bin/tmux new-session -A -s erykksc -c ~)

# If tmux session is exited, attach to the next one
# If none exist, quit
while true; do
    if [[ "$output" != "[exited]" ]]; then
        exit 0
    fi
    output=$(/opt/homebrew/bin/tmux a)
done

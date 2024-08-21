#!/bin/zsh

# Get the current directory name
dir_name=$(basename "$PWD")

# Start home directory tmux session if it doesn't exist
output=$(tmux new-session -A -s $dir_name -c $PWD)

# If tmux session is exited, attach to the next one
# If none exist, quit
while true; do
    if [[ "$output" != "[exited]" ]]; then
        exit 0
    fi
    output=$(tmux a)
done

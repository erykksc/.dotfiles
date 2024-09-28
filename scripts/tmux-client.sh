#!/bin/zsh

# Get the directory path
if [ -z "$1" ]; then
	dir_path=$PWD
else
	dir_path="$1"
fi

dir_name=$(basename "$dir_path")
dir_name="${dir_name//./_}"

tmux new-session -d -s $dir_name -c $dir_path


if [ -n "$TMUX" ]; then
	#Already inside tmux session
	output=$(tmux switch-client -t $dir_name)
else
	output=$(tmux a -t $dir_name)
fi

# If tmux session is exited, attach to the next one
# If none exist, quit
while true; do
	if [[ "$output" != "[exited]" ]]; then
		exit 0
	fi
	output=$(tmux a)
done

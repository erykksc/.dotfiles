#!/bin/bash

search_paths=(~ ~/dev)

selected=$(
	{
		echo "$HOME" # first entry is home to put it as the first result
		echo "$HOME/.local/share/applications"
		find -L "${search_paths[@]}" -mindepth 1 -maxdepth 1 -type d
		find ~/Documents \( -name "node_modules" -o -name ".venv" -o -name ".git" \) -prune -o -type d
		find -L "${search_paths[@]}" -maxdepth 1 -name "*.kitty-session"
	} | fzf --header "Enter: Open Kitty | Ctrl-E: Open in Neovim | Ctrl-Enter: xdg-open" \
		--bind 'ctrl-e:execute(nvim {})+abort' \
		--bind 'ctrl-o:execute(xdg-open {})+abort'
)

if [[ -z $selected ]]; then
	echo "Nothing selected, exiting"
	exit 0
fi

if [[ "$selected" == *.kitty-session ]]; then
	# It's a session file
	kitty --detach --session "$selected"
else
	# It's a directory
	kitty --detach --directory "$selected"
fi

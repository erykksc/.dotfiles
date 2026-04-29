#!/bin/bash

search_paths=(~ ~/dev)

selected=$(
	{
		echo "$HOME" # first entry is home to put it as the first result
		find -L "${search_paths[@]}" -mindepth 1 -maxdepth 1 -type d
		find -L ~/Documents -type d
		find -L "${search_paths[@]}" -maxdepth 2 -name "*.kitty-session"
		find -L "$HOME/.config/kitty" -maxdepth 2 -name "*.kitty-session"
	} | fzf --header "Enter: Open Kitty | Ctrl-E: Open in Neovim" \
		--bind 'ctrl-e:execute(nvim {})+abort'
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

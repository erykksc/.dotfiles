#!/usr/bin/env bash

# file=$(fd . ~ -0 | fzf --read0)
# if [[ -n "$file" ]]; then
# 	# Open the file and immediately detach
# 	xdg-open "$file"
# 	# xdg-open "$file" >/dev/null 2>&1 &
# 	# disown
# fi

# 1. Use fd to find files (regular newlines are better for Rofi than -0)
# 2. Pipe into rofi in dmenu mode
# 3. -i makes it case-insensitive, -p sets the prompt
# FILE=$(fd . ~ --type f --hidden --exclude .git --exclude node_modules | rofi -dmenu -i -p "Open File:")
FILE=$(fd . ~ --hidden --exclude .git --exclude node_modules | fzf)

# 4. If a file was selected (Rofi returns 0 exit code on success)
if [[ -n "$FILE" ]]; then
	# Use setsid to ensure the app is a totally independent process
	setsid xdg-open "$FILE" >/dev/null 2>&1 &
fi

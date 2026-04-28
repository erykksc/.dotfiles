#!/bin/bash
SESSION=$(find ~/.dotfiles/dot-config/kitty/sessions -name "*.kitty-session" | fzf)
if [ -n "$SESSION" ]; then
	kitty --detach --session "$SESSION"
fi

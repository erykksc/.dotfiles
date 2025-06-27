#!/usr/bin/env bash

# Only run this script inside tmux session
if [ -z "$TMUX" ]; then
    echo "This script must be run inside a tmux session."
    exit 1
fi

# Create a temporary file for the pane content
pane_content_file=$(mktemp /tmp/tmux-word-selector-pane-content.XXXXXX)

# Capture the current tmux pane's content
tmux capture-pane -p > "$pane_content_file"

# Extract words, keeping quoted strings (single or double) intact
words=$(perl -ne '
    while (/"[^"]*"|'\''[^'\'']*'\''|\S+/g) {
        $w = $&;
        $w =~ s/^["'\'']//;  # Remove leading quote
        $w =~ s/["'\'']$//;  # Remove trailing quote
        print "$w\n";
    }
' "$pane_content_file")

# Present with fzf
if [ -n "$words" ]; then
    selected_word=$(echo "$words" | fzf --tmux top,100%,20%)
    if [ -n "$selected_word" ]; then
		echo $selected_word | pbcopy
    else
        echo "No word selected."
    fi
else
    echo "No words found."
fi

# Cleanup
rm "$pane_content_file"

#!/usr/bin/env bash

# Only run this script inside tmux session
if [ -z "$TMUX" ]; then
    echo "This script must be run inside a tmux session."
    exit 1
fi

# Create temporary files with arbitrary names and a specific prefix
pane_content_file=$(mktemp /tmp/tmux-url-extractor-pane-content.XXXXXX)
urls_file=$(mktemp /tmp/tmux-url-extractor-urls.XXXXXX)

# Capture the current tmux pane's content
tmux capture-pane -p >"$pane_content_file"

# Extract URLs from the captured content
grep -oE 'http://[^[:space:]]+|https://[^[:space:]]+' "$pane_content_file" >"$urls_file"

# Use fzf to present a selection menu
if [ -s "$urls_file" ]; then
    selected_url=$(cat "$urls_file" | fzf --tmux)

    # Check if a URL was selected
    if [ -n "$selected_url" ]; then
        xdg-open $selected_url
        # You can add further actions here, like opening the URL in a browser
        # xdg-open "$selected_url" # For Linux systems with xdg-open available
    else
        echo "No URL selected."
    fi
else
    echo "No URLs found in the current pane."
fi

# Cleanup
rm "$pane_content_file" "$urls_file"

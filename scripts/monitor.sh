#!/bin/bash

# Check if the tmux session "monitoring" exists
tmux has-session -t monitoring 2>/dev/null

if [ $? != 0 ]; then
  # Start a new tmux session named "monitoring"
  tmux new-session -d -s monitoring

  # Rename the first window and split vertically
  tmux rename-window -t monitoring:0 "Network"
  tmux send-keys -t monitoring:0.0 "ping -a 1.1.1.1" C-m
  tmux split-window -h -t monitoring:0
  tmux send-keys -t monitoring:0.1 "watch nslookup google.com" C-m
  tmux split-window -v -t monitoring:0.1
  tmux send-keys -t monitoring:0.2 "watch -n 60 networkquality" C-m

  # Create a new window and run htop
  tmux new-window -t monitoring -n "System"
  tmux send-keys -t monitoring:1 "htop" C-m
fi

# Check if already inside a tmux session
if [ -n "$TMUX" ]; then
  # Switch to the "monitoring" session
  tmux switch-client -t monitoring
else
  # Attach to the tmux session
  tmux attach -t monitoring
fi

# Switch to window 0 "Network"
tmux select-window -t monitoring:0

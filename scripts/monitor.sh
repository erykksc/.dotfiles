#!/bin/bash

# Check if the tmux session "monitoring" exists
tmux has-session -t monitoring 2>/dev/null

if [ $? != 0 ]; then
  # Start a new tmux session named "monitoring"
  tmux new-session -d -s monitoring

  # Rename the first window and split vertically
  tmux rename-window -t monitoring:1 "Network"
  tmux send-keys -t monitoring:Network "ping -a 1.1.1.1" C-m

  tmux split-window -h -t monitoring:Network
  tmux send-keys -t monitoring:Network.2 "watch nslookup google.com" C-m

  tmux split-window -v -t monitoring:Network.2
  tmux send-keys -t monitoring:Network.3 "watch ifconfig en0" C-m

  tmux split-window -h -t monitoring:Network.3
  tmux send-keys -t monitoring:Network.4 "watch networkquality" C-m

  tmux split-window -v -t monitoring:Network.4
  tmux send-keys -t monitoring:Network.5 "watch traceroute onet.pl" C-m



  #
  # Set layout to tiled
  tmux select-layout -t monitoring:Network tiled

  # Create a new window and run htop
  tmux new-window -t monitoring -n "System"
  tmux send-keys -t monitoring:System "htop" C-m
fi

tmux select-window -t monitoring:Network

# Check if already inside a tmux session
if [ -n "$TMUX" ]; then
  # Switch to the "monitoring" session
  tmux switch-client -t monitoring
else
  # Attach to the tmux session
  tmux attach -t monitoring
fi


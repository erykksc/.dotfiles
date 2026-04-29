#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/wallpapers"

# Pick a random image
RANDOM_PIC=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Check if a file was found
if [ -n "$RANDOM_PIC" ]; then
  # Kill existing hyprpaper instance (if running)
  killall hyprpaper

  # Start hyprpaper in the background
  hyprpaper &

  # Give it a moment to start
  sleep 0.5

  # Set the wallpaper on all monitors
  for MONITOR in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper preload "$RANDOM_PIC"
    hyprctl hyprpaper wallpaper "$MONITOR,$RANDOM_PIC"
  done
else
  echo "No images found in $WALLPAPER_DIR"
  exit 1
fi

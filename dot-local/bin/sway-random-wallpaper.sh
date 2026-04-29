#!/bin/bash

WALLPAPER_DIR="$HOME/wallpapers"

RANDOM_PIC=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Check if a file was actually found
if [ -n "$RANDOM_PIC" ]; then
  # -m fill: can also be 'fit', 'stretch', 'center', 'tile'
  killall swaybg
  swaybg -i "$RANDOM_PIC" -m fill
else
  echo "No images found in $WALLPAPER_DIR"
  exit 1
fi

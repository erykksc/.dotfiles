#!/bin/sh

# set display server protocol
export GDK_BACKEND="wayland,x11,*"
export QT_QPA_PLATFORM="wayland;xcb"
export QT_STYLE_OVERRIDE="kvantum"
export SDL_VIDEODRIVER="wayland"
export CLUTTER_BACKEND="wayland"
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=wayland

# set scaling
# export GDK_SCALE=2
# export QT_SCALE_FACTOR=2

# Run sway, passing all script arguments ("$@") to the sway command
exec sway "$@"

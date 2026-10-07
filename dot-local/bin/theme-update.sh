#!/bin/bash

set -euo pipefail

KITTY_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"

case "${1:-auto}" in
    dark|light)
        APPLY_THEME="$1"
        ;;
    auto)
        if [[ "$(uname -s)" == Darwin ]]; then
            if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark'; then
                APPLY_THEME="dark"
            else
                APPLY_THEME="light"
            fi
        elif [[ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || true)" == "'prefer-dark'" ]]; then
            APPLY_THEME="dark"
        else
            APPLY_THEME="light"
        fi
        ;;
    *)
        echo "Usage: $0 [auto|dark|light]" >&2
        exit 1
        ;;
esac

# Use the same local Tokyo Night palette as Kitty's automatic mode switching.
KITTY_THEME="$KITTY_CONFIG_DIR/$APPLY_THEME-theme.auto.conf"
cp "$KITTY_THEME" "$KITTY_CONFIG_DIR/current-theme.conf"
kitty @ --to "${KITTY_LISTEN_ON:-unix:@mykitty}" set-colors --all --configured "$KITTY_THEME"

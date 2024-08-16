#!/bin/bash

ALACRITTY_CONFIG_FILE="$XDG_CONFIG_HOME/alacritty/alacritty.toml"
LIGHT_ALACRITTY_THEME="$XDG_CONFIG_HOME/alacritty/themes/github_light.toml"
DARK_ALACRITTY_THEME="$XDG_CONFIG_HOME/alacritty/themes/github_dark.toml"

LIGHT_KITTY_THEME="GitHub Light"
DARK_KITTY_THEME="GitHub Dark Dimmed"
#
YAZI_THEME_FILE="$XDG_CONFIG_HOME/yazi/theme.toml"
YAZI_LIGHT_FLAVOR="catppuccin-latte"
YAZI_DARK_FLAVOR="catppuccin-mocha"

# Check if there is user override
if [ "$1" == "dark" ]; then
    APPLY_THEME="dark"
elif [ "$1" == "light" ]; then
    APPLY_THEME="light"
else
    # Otherwise, detect automatically
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q '^Dark'; then
        APPLY_THEME="dark"
    else
        APPLY_THEME="light"
    fi
fi


# Apply the theme
if [ "$APPLY_THEME" == "dark" ]; then
    # Switch to dark theme
    sed -i '' -e "/import = \[/,/\]/c\\
import = [\\
    \"$DARK_ALACRITTY_THEME\",\\
]" $ALACRITTY_CONFIG_FILE
    # sed -i '' -e "s/^use=.*/use=\"$YAZI_DARK_FLAVOR\"/g" $YAZI_THEME_FILE
    # echo '--theme="Catppuccin Mocha"' > $XDG_CONFIG_HOME/bat/config
    kitty +kitten themes --cache-age 1 --reload-in=all $DARK_KITTY_THEME
else
    # Switch to light theme
    sed -i '' -e "/import = \[/,/\]/c\\
import = [\\
    \"$LIGHT_ALACRITTY_THEME\",\\
]" $ALACRITTY_CONFIG_FILE
    # sed -i '' -e "s/^use=.*/use=\"$YAZI_LIGHT_FLAVOR\"/g" $YAZI_THEME_FILE
    # echo '--theme="Catppuccin Latte"' > $XDG_CONFIG_HOME/bat/config
    kitty +kitten themes --cache-age 1 --reload-in=all $LIGHT_KITTY_THEME
fi

#!/bin/bash

ALACRITTY_CONFIG_FILE="$XDG_CONFIG_HOME/alacritty/alacritty.toml"
LIGHT_ALACRITTY_THEME="$XDG_CONFIG_HOME/alacritty/themes/github_light.toml"
DARK_ALACRITTY_THEME="$XDG_CONFIG_HOME/alacritty/themes/github_dark.toml"

LIGHT_KITTY_THEME="Atom One Light"
DARK_KITTY_THEME="OneDark-Pro"

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
#     sed -i '' -e "/import = \[/,/\]/c\\
# import = [\\
#     \"$DARK_ALACRITTY_THEME\",\\
# ]" $ALACRITTY_CONFIG_FILE
    kitty +kitten themes --cache-age 1 --reload-in=all $DARK_KITTY_THEME
else
    # Switch to light theme
#     sed -i '' -e "/import = \[/,/\]/c\\
# import = [\\
#     \"$LIGHT_ALACRITTY_THEME\",\\
# ]" $ALACRITTY_CONFIG_FILE
    kitty +kitten themes --cache-age 1 --reload-in=all $LIGHT_KITTY_THEME
fi

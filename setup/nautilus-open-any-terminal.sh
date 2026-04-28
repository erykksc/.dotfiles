#!/usr/bin/env bash

# This script configures the nautilus-open-any-terminal for ghostty

sudo dnf copr enable -y monkeygold/nautilus-open-any-terminal
sudo dnf install -y nautilus-open-any-terminal

sudo glib-compile-schemas /usr/share/glib-2.0/schemas
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
nautilus -q

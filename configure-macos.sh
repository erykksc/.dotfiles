#!/usr/bin/env zsh

# CONFIGURE MACOS

# Set the initial key repeat rate (lower values mean shorter delay before repeat starts)
defaults write -g InitialKeyRepeat -int 15

# Set the key repeat rate (lower values mean faster repeat)
defaults write -g KeyRepeat -int 2

# Enable auto-hide for the Dock
defaults write com.apple.dock autohide -bool true

# Disable the automatic rearrangement of Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# MANUAL: Enable tap to click on trackpad

# Restart Dock to apply changes
killall Dock

# Restart Finder to apply changes
killall Finder


# INSTALL HOMEBREW APPS
# update homebrew packages
brew update && brew upgrade && brew autoremove && brew cleanup
# install packages from Brewfile
brew bundle


# INSTALL MAC APP STORE APPS
# In order for this part of the script to work one needs to be
# signed into the Mac App Store

APP_IDS=(
    948660805  # AusweisApp
    1352778147 # Bitwarden
    441258766  # Magnet
    1451685025 # WireGuard
    1480933944 # Vimari


    1440147259 # AdGuard for Safari
    497799835  #  Xcode
    640199958  #  Developer
    409183694  #  Keynote
    # 997079563 #  Kiwix
    1568262835 # superagent
    1591303229 # Vinegar
    # 462058435 #  Microsoft Excel
    409201541  #  Pages
    # 462054704 #  Microsoft Word
    409203825  #  Numbers
    # 1462114288 # Grammarly for Safari
    897446215  #  Canva
)

# Install apps using their Mac App Store IDs
for APP_ID in "${APP_IDS[@]}"; do
    echo "Installing app with ID $APP_ID..."
    mas install "$APP_ID"
done
mas upgrade

wait


echo "Installation complete!"

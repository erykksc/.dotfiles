#!/bin/bash

set -euo pipefail

echo "Detecting package manager"
if command -v brew >/dev/null 2>&1; then
    INSTALL_CMD="brew install"
    UPDATE_CMD="brew update"
elif command -v apt-get >/dev/null 2>&1; then
    INSTALL_CMD="apt-get -y install"
    UPDATE_CMD="apt-get update"
elif command -v dnf >/dev/null 2>&1; then
    INSTALL_CMD="dnf -y install"
    UPDATE_CMD="dnf check-update"
elif command -v yum >/dev/null 2>&1; then
    INSTALL_CMD="yum -y install"
    UPDATE_CMD="yum check-update"
elif command -v pacman >/dev/null 2>&1; then
    INSTALL_CMD="pacman -S --noconfirm"
    UPDATE_CMD="pacman -Sy"
elif command -v zypper >/dev/null 2>&1; then
    INSTALL_CMD="zypper install -y"
    UPDATE_CMD="zypper refresh"
else
    echo "No supported package manager found on this system."
    exit 1
fi

echo "Running" $UPDATE_CMD
$UPDATE_CMD

echo "Detected install command:" $INSTALL_CMD

# Install git if not available
if ! command -v git >/dev/null 2>&1; then
    echo "git not detected, installing it"
    $INSTALL_CMD git
fi

echo Cloning .dotfiles repository to ~/.dotfiles
if [[ $1 == "--git-https" ]]; then
    echo "Detected --git-https flag, cloning using https"
    git clone https://github.com/erykksc/.dotfiles.git ~/.dotfiles
else
    git clone git@github.com:erykksc/.dotfiles.git ~/.dotfiles
fi

echo "Installing stow"
$INSTALL_CMD stow

echo "Symlinking .dotfiles"
(
    cd ~/.dotfiles && stow -vR .
)

echo "Installing basic packages"
$INSTALL_CMD zsh tmux fzf neovim ripgrep

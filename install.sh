#!/bin/sh

set -e


# Determine if sudo is needed
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        echo "This script must be run as root or have 'sudo' available."
        exit 1
    fi
fi

echo "Detecting package manager"
if command -v brew >/dev/null 2>&1; then
    INSTALL_CMD="brew install"
    UPDATE_CMD="brew update"
    PACKAGE_CHECK_CMD="brew list"
elif command -v apt-get >/dev/null 2>&1; then
    INSTALL_CMD="$SUDO apt-get -y install"
    UPDATE_CMD="$SUDO apt-get update"
    PACKAGE_CHECK_CMD="dpkg -s"
elif command -v dnf >/dev/null 2>&1; then
    INSTALL_CMD="$SUDO dnf -y install"
    UPDATE_CMD="$SUDO dnf check-update"
    PACKAGE_CHECK_CMD="rpm -q"
elif command -v yum >/dev/null 2>&1; then
    INSTALL_CMD="$SUDO yum -y install"
    UPDATE_CMD="$SUDO yum check-update"
    PACKAGE_CHECK_CMD="rpm -q"
elif command -v pacman >/dev/null 2>&1; then
    INSTALL_CMD="$SUDO pacman -S --noconfirm"
    UPDATE_CMD="$SUDO pacman -Sy"
    PACKAGE_CHECK_CMD="pacman -Qi"
elif command -v zypper >/dev/null 2>&1; then
    INSTALL_CMD="$SUDO zypper install -y"
    UPDATE_CMD="$SUDO zypper refresh"
    PACKAGE_CHECK_CMD="rpm -q"
else
    echo "No supported package manager found on this system."
    exit 1
fi

echo "Running update: $UPDATE_CMD"
$UPDATE_CMD

# Install package if not already installed
install_if_missing() {
    pkg=$1
    echo "Checking if $pkg is installed..."
    if ! $PACKAGE_CHECK_CMD "$pkg" >/dev/null 2>&1; then
        echo "Installing $pkg..."
        $INSTALL_CMD "$pkg"
    else
        echo "$pkg already installed."
    fi
}

# Ensure git is installed
install_if_missing git

# Clone dotfiles repo if not already cloned
DOTFILES_DIR="$HOME/.dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning .dotfiles repository to $DOTFILES_DIR"
    if [ "$1" = "--git-https" ]; then
        echo "Detected --git-https flag, cloning using HTTPS"
        git clone https://github.com/erykksc/.dotfiles.git "$DOTFILES_DIR"
    else
        git clone git@github.com:erykksc/.dotfiles.git "$DOTFILES_DIR"
    fi
else
    echo ".dotfiles already cloned at $DOTFILES_DIR"
fi

# Ensure stow is installed
install_if_missing stow

# Run stow to symlink
echo "Running stow to symlink dotfiles"
(
    cd "$DOTFILES_DIR" && stow -vR .
)

# Install basic tools if missing
set +e
for pkg in zsh tmux neovim direnv fzf ripgrep starship bat eza yazi; do
    install_if_missing "$pkg"
done
set -e

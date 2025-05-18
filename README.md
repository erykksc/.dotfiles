# About repo
This repo contains my personal configurations and scripts.

# How to install

## One command install:

### Install with github ssh key
```zsh
curl -fsSL https://raw.githubusercontent.com/erykksc/.dotfiles/refs/heads/main/install.sh | bash
```

### Install without ssh key
```zsh
curl -fsSL https://raw.githubusercontent.com/erykksc/.dotfiles/refs/heads/main/install.sh | bash -s -- --git-https
```

### Clone repository
```zsh
git clone git@github.com:erykksc/.dotfiles.git ~/.dotfiles
```

### Install Homebrew
https://brew.sh

### Symlink configuration files
Stow is required for this operation
```zsh
brew install stow
cd ~/.dotfiles
stow .
brew uninstall stow
```

### Mac App Store
Sign in to mac app store manually

### Run installation script
```zsh
cd ~/.dotfiles
./configure-macos.sh
```

### Tap to click
Enable tap to click on trackpad in 'System Settings.app'


### Install Nix
https://nixos.org/download/


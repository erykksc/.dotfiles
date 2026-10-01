# About repo

This repo contains my personal configurations and scripts.

# How to install

## One command install:

### Install with github ssh key

```zsh
curl -fsSL https://raw.githubusercontent.com/erykksc/.dotfiles/refs/heads/main/install.sh | sh
```

### Install without ssh key

```zsh
curl -fsSL https://raw.githubusercontent.com/erykksc/.dotfiles/refs/heads/main/install.sh | sh -s -- --git-https
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

### Quick Linux setup for Herdr

Install Mise, GNU Stow, Bash, jq, and Neovim. Clone the repo, install Herdr and
lazygit from its Mise config, link the dotfiles, and check the Herdr config:

```sh
git clone git@github.com:erykksc/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
mise install herdr lazygit
stow .
HERDR_CONFIG_PATH="$HOME/.config/herdr/config.toml" herdr config check
```

Launch `herdr` in the directory where you want to work. Herdr's config and
helpers work independently of Kitty. Kitty's key forwarding is an optional
companion. See [Herdr setup, shortcuts, and rollback](dot-config/herdr/README.md).

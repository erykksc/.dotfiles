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

### Zen Browser shortcuts on Linux

The full shortcut configuration is stored in the Stow package
[setup/zen/zen-keyboard-shortcuts.json](setup/zen/zen-keyboard-shortcuts.json).
It includes the working Ctrl+Shift+1–7 workspace bindings (workspace 8 is
currently unbound) and clears the
DevTools DOM panel binding that conflicts with Ctrl+Shift+W (Close Window).

On another Linux machine, start Zen once to initialize its profile. Find its
profile directory in `about:profiles`, quit Zen, and replace the example profile
path below with that directory:

```sh
cd ~/.dotfiles
zen_profile="$HOME/.zen/<profile-directory>"
mv "$zen_profile/zen-keyboard-shortcuts.json" \
   "$zen_profile/zen-keyboard-shortcuts.json.backup-$(date +%Y%m%d-%H%M%S)"
stow --dir=setup --target="$zen_profile" zen
```

Start Zen again to load the linked configuration. This package is applied
separately from `stow .` because Zen's profile directory name varies between
machines. The existing `.stowrc` excludes `setup` from the main Stow operation.
Zen 1.22.3b was verified to preserve the symlink when saving shortcuts, so
changes made in Settings also update the tracked file. This shares the entire
shortcut configuration; check its Git diff after changing settings or updating
Zen. Keep Zen closed while applying this package or pulling shortcut changes.

The workspace bindings use the shifted symbols `!@#$%^&` for number keys 1–7,
as verified in Zen 1.22.3b on Linux. Adjust the symbols in the configuration if
your keyboard layout differs. Settings may display those symbols; physically
press Ctrl+Shift+1–7. Rebinding through Zen's Settings may restore the broken
digit representation; edit the tracked file with Zen closed if needed.

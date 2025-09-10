#!/usr/bin/env bash

set -euo pipefail
set -x

# upgrade system
sudo pacman -Syu

# install yay
if yay --version >/dev/null 2>&1; then
	echo "Yay already installed"
else
	sudo pacman -S --noconfirm \
		git \
		base-devel
	cd /tmp
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	yay -Syu --noconfirm
	rm -rf /tmp/yay
	cd $HOME
fi

# Distro
sudo pacman --needed --noconfirm -S \
	waybar \
	wofi \
	bluez \
	bluez-utils \
	ttf-jetbrains-mono-nerd \
	mako \
	polkit-kde-agent \
	wl-clipboard \
	xdg-desktop-portal-hyprland

sudo systemctl enable --now bluetooth.service

# CLI tools
sudo pacman --needed --noconfirm -S \
	zsh \
	tmux \
	rsync \
	man-db \
	man-pages \
	curl \
	openssh \
	git \
	git-delta \
	git-lfs \
	github-cli \
	fd \
	ripgrep \
	watchexec \
	neovim \
	fzf \
	docker \
	direnv \
	pnpm \
	base-devel

yay --needed --noconfirm -S \
	tlrc-bin

# GUI tools
sudo pacman --needed --noconfirm -S \
	ghostty  \
	bitwarden

yay --needed --noconfirm -S \
	zen-browser-bin \
	spotify

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]] then
	chsh -s /bin/zsh
fi

# Setup docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Install Nix
if command -v nix > /dev/null 2>&1; then
	echo "nix already installed"
else
	curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
	# enable nix
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# install the nix-direnv (caching for direnv)
# needs new shell to make sure that `nix` is accessible there
(zsh -c 'nix profile add "nixpkgs#nix-direnv"')


# Setup github
# if gh auth status &>/dev/null; then
# 	echo "✅ Already logged in to GitHub CLI"
# else
# 	echo "🔑 Logging into GitHub CLI..."
# 	gh auth login --hostname github.com --git-protocol ssh --web
# fi

# create default ssh key
if [[ ! -f "$HOME/.ssh/id_ed25519" ]] then
	ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
fi

if [[ ! -d "$HOME/.dotfiles" ]] then
	git clone git@github.com:erykksc/.dotfiles.git
fi

(
	cd "$HOME/.dotfiles"
	nix run "nixpkgs#stow" -- -R .
)

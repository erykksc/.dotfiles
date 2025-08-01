#!/bin/bash

set -e
set -o pipefail
set -x

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

# Install user packages
sudo pacman -S --noconfirm \
	bitwarden \
	dolphin \
	ghostty \
	hyprpaper \
	mako \
	pavucontrol \
	polkit-kde-agent \
	ttf-jetbrains-mono-nerd \
	waybar \
	wl-clipboard \
	wofi \
	xdg-desktop-portal-hyprland

# Install CLI tools
sudo pacman -S --noconfirm \
	bat \
	btop \
	direnv \
	fd \
	fzf \
	git \
	git-delta \
	git-lfs \
	github-cli \
	man-db \
	man-pages \
	minikube \
	mosh \
	neovim \
	openssh \
	rsync \
	starship \
	tmux \
	uv \
	watchexec \
	wget \
	zsh

yay -S --noconfirm \
	zen-browser-bin \
	tlrc-bin \
	prettierd \
	nodejs-localtunnel \
	ripgreg

# create default ssh key
ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"

# setup docker
sudo pacman -S --noconfirm docker
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# install nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --yes --no-confirm

# install the nix-direnv (caching for direnv)
# needs new shell to make sure that `nix` is accessible there
(zsh -c 'nix profile add "nixpkgs#nix-direnv"')


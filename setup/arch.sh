#!/usr/bin/env bash

if [[ ! -f /etc/arch-release ]]; then
	echo "THIS SCRIPT ONLY WORKS ON ARCH!!!"
	exit 1
fi

set -euo pipefail
set -x

# copy defaults
sudo cp ~/.dotfiles/etc/pacman.conf /etc/pacman.conf

# upgrade system
sudo pacman -Syu --noconfirm

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
	rofi \
	bluez \
	bluez-utils \
	ttf-jetbrains-mono-nerd \
	swaync \
	polkit-kde-agent \
	wl-clipboard \
	xdg-desktop-portal-hyprland \
	hyprpaper \
	hyprsunset \
	papirus-icon-theme \
	wireguard-tools

sudo systemctl enable --now bluetooth.service

# CLI tools
sudo pacman --needed --noconfirm -S \
	zsh \
	tmux \
	rsync \
	man-db \
	go \
	man-pages \
	traceroute \
	curl \
	openssh \
	git \
	git-delta \
	git-lfs \
	github-cli \
	fd \
	ripgrep \
	watchexec \
	fzf \
	docker \
	direnv \
	pnpm \
	keyd \
	btop \
	base-devel
# neovim \

# GUI tools
sudo pacman --needed --noconfirm -S \
	ghostty \
	bitwarden \
	flatpak \
	flameshot \
	okular \
	dolphin \
	discord \
	kio-extras \
	libreoffice-fresh \
	nautilus \
	sushi \
	thunar \
	rofimoji \
	chromium \
	wtype \
	telegram-desktop \
	thunderbird

yay --needed --noconfirm -S \
	tlrc-bin \
	vial-appimage \
	wlogout \
	synology-drive

flatpak install --assumeyes \
	flathub \
	org.kde.CrowTranslate

# xdg-settings set default-web-browser zen-browser.desktop
# xdg-mime default org.pwmt.zathura.desktop application/pdf

# TODO:
# messenger
# login in browser to perplexity, chatgpt, google accounts, github, tu berlin
# login in thunderbird to email accounts
# wireguard client
# preview in file manager on space press
# ausweis app (create a windows VM setup)
# go through every utility
# rice just a tiny (one day project)

yay --needed --noconfirm -S \
	zen-browser-bin \
	spotify

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

sudo mkdir -p /etc/keyd
sudo cp $HOME/.dotfiles/etc/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo keyd reload

# Setup docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Install Nix
if command -v nix >/dev/null 2>&1; then
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
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
	ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
fi

if [[ ! -d "$HOME/.dotfiles" ]]; then
	git clone git@github.com:erykksc/.dotfiles.git
fi

(
	cd "$HOME/.dotfiles"
	nix run "nixpkgs#stow" -- -R .
)

sudo usermod -aG input $USER

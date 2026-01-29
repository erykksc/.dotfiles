#!/usr/bin/env bash

if [[ ! -f /etc/fedora-release ]]; then
	echo "THIS SCRIPT ONLY WORKS ON FEDORA!!!"
	exit 1
fi

set -euo pipefail
set -x

mkdir -p $HOME/dev

# enable RPM Fusion repositories
# enable free repository
sudo dnf install \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# enable nonfree repository
sudo dnf install \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# upgrade system
sudo dnf update -y

# CLI tools
sudo dnf install -y \
	zsh \
	rsync \
	man-db \
	man-pages \
	traceroute \
	curl \
	openssh \
	gcc \
	clang \
	make \
	cmake \
	git \
	geary \
	dbus-devel \
	glib2-devel \
	docker \
	docker-compose \
	postgresql
# docker
# keyd \
# watchexec \
# base-devel
# neovim \

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

# Setup docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Install Nix
# if command -v nix >/dev/null 2>&1; then
# 	echo "nix already installed"
# else
# 	curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm \
# 		--extra-conf "tarball-ttl = 604800" # update nixpkgs automatically on nix run only once a week
# 	# enable nix
# 	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
# fi
#
# nix profile upgrade --all
#
# (
# 	cd "$HOME/.dotfiles"
# 	nix run "nixpkgs#stow" -- -R .
# )

# install the nix-direnv (caching for direnv)
# needs new shell to make sure that `nix` is accessible there
# (zsh -c 'nix profile add "nixpkgs#nix-direnv"')

# create default ssh key
# if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
# 	ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)" -f $HOME/.ssh/id_ed25519
# fi

# Setup github
# if gh auth status &>/dev/null; then
# 	echo "✅ Already logged in to GitHub CLI"
# else
#	jetbrains-mono-nl-fonts
# 	echo "🔑 Logging into GitHub CLI..."
# 	gh auth login --hostname github.com --git-protocol ssh --web
# fi

sudo usermod -aG input $USER

sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y alternateved/keyd

# Distro
sudo dnf install -y \
	keyd \
	ghostty \
	kernel-headers \
	v4l2loopback

sudo dnf group install -y multimedia --with-optional
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

# ttf-jetbrains-mono-nerd \
# polkit-kde-agent \
# wtype \
# wireguard-tools \
# jetbrains-mono-nl-fonts

# sudo systemctl enable --now bluetooth.service

# GUI tools
# sudo pacman --needed --noconfirm -S \
# 	ghostty \
# 	okular \
# 	discord \
# 	kio-extras \
# 	libreoffice-fresh \
# 	nautilus \
# 	sushi \
# 	rofimoji \
# 	chromium \
# 	telegram-desktop \
# 	kdeconnect \
# 	thunderbird

if command -v mise >/dev/null 2>&1; then
	echo "mise already installed"
else
	curl https://mise.run | sh
	mise install
fi

# yay --needed --noconfirm -S \
# 	vial-appimage \
# 	synology-drive \
# 	zen-browser-bin \
# 	spotify
# # wlogout \
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install --assumeyes \
	flathub \
	com.bitwarden.desktop \
	com.spotify.Client \
	com.synology.SynologyDrive \
	com.super_productivity.SuperProductivity \
	com.discordapp.Discord \
	org.localsend.localsend_app \
	com.mattjakeman.ExtensionManager \
	us.zoom.Zoom \
	it.mijorus.smile \
	com.obsproject.Studio \
	com.obsproject.Studio.Plugin.DroidCam \
	com.slack.Slack

# setup droidcam
# obs and droid cam are required from flatpak
flatpak override --user --device=all com.obsproject.Studio

# xdg-settings set default-web-browser zen-browser.desktop
# xdg-mime default org.pwmt.zathura.desktop application/pdf

# TODO:
# messenger
# login in browser to perplexity, chatgpt, google accounts, github, tu berlin
# login in thunderbird to email accounts
# wireguard client
# ausweis app (create a windows VM setup)
# rice just a tiny (one day project) go through every utility

sudo mkdir -p /etc/keyd
sudo cp $HOME/.dotfiles/etc/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
sudo keyd reload

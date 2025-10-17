#!/usr/bin/env bash


if [[ ! -f /etc/arch-release ]]; then
	echo "THIS SCRIPT ONLY WORKS ON ARCH!!!"
	exit 1
fi

set -euo pipefail
set -x

# install nix
./dev-nix.sh

# copy defaults
sudo cp $HOME/.dotfiles/etc/pacman.conf /etc/pacman.conf
sudo cp $HOME/.dotfiles/setup/static/sway-nvidia.desktop /usr/share/wayland-sessions/sway-nvidia.desktop

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
	brightnessctl \
	rofi \
	bluez \
	bluez-utils \
	ttf-jetbrains-mono-nerd \
	swaync \
	swaylock \
	polkit-kde-agent \
	wl-clipboard \
	xdg-desktop-portal-hyprland \
	hyprpaper \
	hyprsunset \
	papirus-icon-theme \
	flatpak \
	flameshot \
	wtype \
	noto-fonts-emoji \
	wireguard-tools

sudo systemctl enable --now bluetooth.service

# CLI tools
sudo pacman --needed --noconfirm -S \
	rsync \
	man-db \
	man-pages \
	curl \
	openssh \
	docker \
	pnpm \
	keyd \
	base-devel
# neovim \

# GUI tools
sudo pacman --needed --noconfirm -S \
	ghostty \
	bitwarden \
	okular \
	kio-extras \
	libreoffice-fresh \
	nautilus \
	sushi \
	rofimoji \
	chromium \
	kdeconnect

yay --needed --noconfirm -S \
	vial-appimage
# wlogout \

flatpak install --assumeyes \
	flathub \
	org.kde.CrowTranslate \
	app.zen_browser.zen \
	com.spotify.Client \
	com.synology.SynologyDrive \
	com.discordapp.Discord \
	org.localsend.localsend_app \
	org.mozilla.Thunderbird \
	org.telegram.desktop

# TODO: set defaults
# xdg-settings set default-web-browser zen-browser.desktop
# xdg-mime default org.pwmt.zathura.desktop application/pdf

# TODO: create webapps
# facebook messenger
# whatsapp web

# TODO:
# login in thunderbird to email accounts
# wireguard client
# ausweis app (create a windows VM setup)

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

mkdir -p $HOME/dev

sudo mkdir -p /etc/keyd
sudo cp $HOME/.dotfiles/etc/keyd/default.conf /etc/keyd/default.conf
sudo usermod -aG input $USER
sudo systemctl enable --now keyd
sudo keyd reload

# Setup docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# create default ssh key
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
	ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
fi

# Setup github
if gh auth status &>/dev/null; then
	echo "✅ Already logged in to GitHub CLI"
else
	echo "🔑 Logging into GitHub CLI..."
	gh auth login --hostname github.com --git-protocol ssh
fi

if [[ ! -d "$HOME/.dotfiles" ]]; then
	git clone git@github.com:erykksc/.dotfiles.git
fi

# install dotfiles
(
	cd "$HOME/.dotfiles"
	nix run "nixpkgs#stow" -- -R .
)

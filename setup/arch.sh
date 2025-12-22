#!/usr/bin/env bash

if [[ ! -f /etc/arch-release ]]; then
	echo "THIS SCRIPT ONLY WORKS ON ARCH!!!"
	exit 1
fi

set -euo pipefail
set -x

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
	blueman \
	ttf-jetbrains-mono-nerd \
	swaync \
	wl-clipboard \
	wlsunset \
	ufw \
	fail2ban \
	papirus-icon-theme \
	flatpak \
	flameshot \
	wtype \
	noto-fonts-emoji \
	xdg-desktop-portal-wlr \
	xdg-desktop-portal-gtk \
	xdg-desktop-portal \
	qt5-wayland \
	qt6-wayland \
	kwayland-integration \
	polkit-kde-agent \
	fprintd \
	tlp \
	tlp-rdw \
	tp_smapi \
	acpi_call \
	wireguard-tools

sudo systemctl enable tlp.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

# Hyprland
sudo pacman --needed --noconfirm -S \
	hyprland \
	hyprpaper \
	hyprlock \
	hyprsunset

# CLI tools
sudo pacman --needed --noconfirm -S \
	rsync \
	man-db \
	man-pages \
	curl \
	openssh \
	docker \
	docker-compose \
	docker-buildx \
	swaylock \
	keyd \
	base-devel \
	mise \
	usage \
	fzf \
	fd \
	stow \
	git \
	github-cli \
	ncdu \
	nodejs \
	npm \
	go \
	golangci-lint \
	cmake \
	make \
	zsh \
	tmux

# neovim \

# GUI tools
sudo pacman --needed --noconfirm -S \
	ghostty \
	bitwarden \
	okular \
	kio-extras \
	libreoffice-fresh \
	thunar \
	rofimoji \
	chromium \
	firefox \
	kdeconnect \
	thunderbird \
	telegram-desktop
# "fat" file manager
# nautilus \
# sushi \

yay --needed --noconfirm -S \
	vial-appimage \
	sioyek-appimage \
	superproductivity-bin

flatpak install --assumeyes \
	flathub \
	com.spotify.Client \
	com.synology.SynologyDrive \
	com.discordapp.Discord \
	org.localsend.localsend_app \
	com.slack.Slack

# TODO: set defaults
# xdg-settings set default-web-browser zen-browser.desktop
# xdg-mime default org.pwmt.zathura.desktop application/pdf
xdg-settings set default-web-browser firefox.desktop
# xdg-mime default sioyek.desktop application/pdf

sudo systemctl enable --now bluetooth.service
sudo ufw allow 22/tcp
sudo ufw enable
sudo systemctl enable --now fail2ban
sudo systemctl enable --now sshd
# TODO: create webapps
# facebook messenger
# whatsapp web

# TODO:
# login in thunderbird to email accounts
# wireguard client
# windows VM setup
# ausweis app (create a windows VM setup)

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

mkdir -p $HOME/dev

# Setup docker
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# create default ssh key
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
	ssh-keygen -t ed25519 -C "$(whoami)@$(uname -n)"
fi

# Setup github
# if gh auth status &>/dev/null; then # 	echo "✅ Already logged in to GitHub CLI"
# else
# 	echo "🔑 Logging into GitHub CLI..."
# 	gh auth login --hostname github.com --git-protocol ssh
# fi

if [[ ! -d "$HOME/.dotfiles" ]]; then
	git clone git@github.com:erykksc/.dotfiles.git
fi

# install dotfiles
(
	cd "$HOME/.dotfiles"
	stow -R .
)

# copy defaults
sudo cp $HOME/.dotfiles/etc/pacman.conf /etc/pacman.conf
sudo cp $HOME/.dotfiles/etc/locale.gen /etc/locale.gen
sudo cp $HOME/.dotfiles/setup/static/sway-nvidia.desktop /usr/share/wayland-sessions/sway-nvidia.desktop

sudo mkdir -p /etc/keyd
sudo cp $HOME/.dotfiles/etc/keyd/default.conf /etc/keyd/default.conf
sudo usermod -aG input $USER
sudo systemctl enable --now keyd
sudo keyd reload

# set dark theme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

sudo locale-gen

echo "options hid_apple fnmode=2 swap_opt_cmd=1" | sudo tee /etc/modprobe.d/lofree-fn-fix.conf

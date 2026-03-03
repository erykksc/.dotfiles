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

sudo usermod -aG input $USER

sudo dnf copr enable -y scottames/ghostty
sudo dnf copr enable -y alternateved/keyd
sudo dnf copr enable -y jdxcode/mise

# Distro
sudo dnf install -y \
	keyd \
	ghostty \
	mise \
	kernel-headers \
	v4l2loopback \
	sqlite \
	sqlite-devel \
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
	postgresql \
	ffmpeg

# install brave browser
sudo dnf install dnf-plugins-core
if [ ! -f "/etc/yum.repos.d/brave-browser.repo" ]; then
	sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
else
	echo "Brave repository already configured."
fi
sudo dnf install brave-browser

# setup video codecs
sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

sudo dnf5 group upgrade -y multimedia --setopt=install_weak_deps=0 --exclude=PackageKit-gstreamer-plugin
sudo dnf install libavcodec-freeworld
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

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
	org.kde.kdenlive \
	fr.handbrake.ghb \
	com.slack.Slack

# setup droidcam
# obs and droid cam are required from flatpak
flatpak override --user --device=all com.obsproject.Studio

# Setup ZSH as shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ $CURRENT_SHELL != "/bin/zsh" ]]; then
	chsh -s /bin/zsh
fi

# docker setup
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# keyd setup
./keyd.sh

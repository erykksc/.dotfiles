#!/usr/bin/env bash

set -euo pipefail
set -x

sudo mkdir -p /etc/keyd
sudo cp $HOME/.dotfiles/etc/keyd/default.conf /etc/keyd/default.conf
sudo usermod -aG input $USER
sudo systemctl enable --now keyd
sudo keyd reload

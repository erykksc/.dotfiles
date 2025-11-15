#!/usr/bin/env bash

set -euo pipefail
set -x

# Install Nix
if command -v nix >/dev/null 2>&1; then
	echo "nix already installed"
else
	curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm \
		--extra-conf "tarball-ttl = 604800" # update nixpkgs automatically on nix run only once a week
	# enable nix
	. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix profile upgrade --all

nix profile add \
	'nixpkgs#btop' \
	'nixpkgs#cmake' \
	'nixpkgs#codex' \
	'nixpkgs#delta' \
	'nixpkgs#devcontainer' \
	'nixpkgs#direnv' \
	'nixpkgs#fd' \
	'nixpkgs#fzf' \
	'nixpkgs#gh' \
	'nixpkgs#git' \
	'nixpkgs#git-lfs' \
	'nixpkgs#go' \
	'nixpkgs#golangci-lint' \
	'nixpkgs#mosh' \
	'nixpkgs#nix-direnv' \
	'nixpkgs#nixfmt-rfc-style' \
	'nixpkgs#pnpm' \
	'nixpkgs#prettier' \
	'nixpkgs#prettierd' \
	'nixpkgs#python3' \
	'nixpkgs#ripgrep' \
	'nixpkgs#tlrc' \
	'nixpkgs#tmux' \
	'nixpkgs#zsh' \
	'nixpkgs#tree' \
	'nixpkgs#uv' \
	'nixpkgs#watch' \
	'nixpkgs#watchexec' \
	'nixpkgs#wget'

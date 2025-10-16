#!/usr/bin/env bash

set -euo pipefail

if [[ -f 'flake.nix' ]]; then
  echo "ERROR: File flake.nix already exists"
  exit 1
fi


cat > 'flake.nix' <<'EOF'
{
  description = "Flake with the development environment for the project";

  inputs = {
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs-linux,
      nixpkgs-darwin,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs =
          import (if builtins.match ".*-darwin" system != null then nixpkgs-darwin else nixpkgs-linux)
            {
              inherit system;
            };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nixfmt-rfc-style
          ];
        };
      }
    );
}
EOF

echo "wrote flake.nix"

if [[ -f '.envrc' ]]; then
  echo "ERROR: File .envrc already exists"
  exit 1
fi

echo 'use flake' > '.envrc'
echo "wrote .envrc"

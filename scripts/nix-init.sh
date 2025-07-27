#!/usr/bin/env bash

set -euo pipefail

if [[ -f 'flake.nix' ]]; then
  echo "ERROR: File flake.nix already exists"
  exit 1
fi


cat > 'flake.nix' <<'EOF'
{
  description = "A basic flake with definition of development shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
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

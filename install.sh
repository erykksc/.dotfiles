nix --extra-experimental-features nix-command --extra-experimental-features flakes \
    run 'nixpkgs#stow' -- -R .

nix profile add "nixpkgs#{
zsh,
btop,
cmake
}"
    "nixpkgs#zsh' \
    'nixpkgs#btop' \
    'nixpkgs#cmake' \
    'nixpkgs#codex' \
nix profile add \
    'nixpkgs#zsh' \
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
    'nixpkgs#mosh' \
    'nixpkgs#neovim' \
    'nixpkgs#nix-direnv' \
    'nixpkgs#nixfmt-rfc-style' \
    'nixpkgs#nodejs' \
    'nixpkgs#pnpm' \
    'nixpkgs#prettier' \
    'nixpkgs#prettierd' \
    'nixpkgs#python3' \
    'nixpkgs#ripgrep' \
    'nixpkgs#tlrc' \
    'nixpkgs#tmux' \
    'nixpkgs#tree' \
    'nixpkgs#uv' \
    'nixpkgs#watch' \
    'nixpkgs#watchexec' \
    'nixpkgs#wget'

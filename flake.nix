{
  description = "Erykksc's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # Necessary if using determinate system installer of nix
      nix.enable = false;

      environment.systemPackages = with pkgs; [
        bat
        eza
        fzf
        gh
        git-lfs
        htop
        mosh
        neovim
        ripgrep
        starship
        tlrc
        tmux
        watch
        wget
        yazi
      ];

      homebrew.casks = [
        "anki"
        "audacity"
        "background-music"
        "brave-browser"
        "calibre"
        "chatbox"
        "claude"
        "cursor"
        "db-browser-for-sqlite"
        "discord"
        "docker"
        "font-fira-code-nerd-font"
        "foxitreader"
        "ghostty"
        "gimp"
        "godot"
        "handbrake"
        "hiddenbar"
        "homerow"
        "karabiner-elements"
        "keyboardcleantool"
        "libreoffice"
        "mac-mouse-fix"
        "mactex-no-gui"
        "messenger"
        "netdownloadhelpercoapp"
        "qlvideo"
        "raycast"
        "skim"
        "slack"
        "spotify"
        "steam"
        "synology-drive"
        "syntax-highlight"
        "telegram"
        "vial"
        "vlc"
        "webpquicklook"
        "whatsapp"
        "windows-app"
        "wireshark"
        "zoom"
      ];

      homebrew.masApps = {
        "AusweisApp" = 948660805;
        "Bitwarden" = 1352778147;
        "Magnet" = 441258766;
        "Vinegar" = 1591303229;
        "WireGuard" = 1451685025;
      };


      system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
      system.defaults.NSGlobalDomain.KeyRepeat = 1;

      system.defaults.dock.autohide = true;
      system.defaults.dock.mru-spaces = false;

      system.defaults.finder.AppleShowAllExtensions = true;

      system.defaults.trackpad.Clicking = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";


      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#eryk-macbook
    darwinConfigurations."eryk-macbook" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}

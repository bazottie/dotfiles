{
  description = "nix-darwin flake for my Macbooks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      system.primaryUser = "bazottie";
      environment.systemPackages = with pkgs; [
		fzf
		neovim
		php
		deno
		git-lfs
		lazygit
		neovim
		zoxide
		difftastic
		mise
		];

        homebrew = {
            enable = true;
            brews = [
            "zsh"
            "mas"
            "openjdk"
            "composer"
            "pyenv"
            "pipx"
            "oh-my-posh"
            ];
            casks = [
            "bitwarden"
            "discord"
            "figma"
            "google-chrome"
            "monitorcontrol"
            "orbstack"
            "raycast"
            "rectangle"
            "scroll-reverser"
            "slack"
            "steam"
            "visual-studio-code"
            "webstorm"
            "proton-drive"
            "postman"
            ];
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
        };


      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";
      nix.enable=false;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

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
    # $ darwin-rebuild build --flake .#Bass-MacBook-Pro
    darwinConfigurations."book" = nix-darwin.lib.darwinSystem {
      modules = [
      nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;

                  # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                  enableRosetta = true;

                  # User owning the Homebrew prefix
                  user = "bazottie";

                  # Optional: Declarative tap management
                  taps = {
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                  };

                  # Optional: Enable fully-declarative tap management
                  #
                  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                  mutableTaps = false;
                };
              }
                ({config, ...}: {
                        homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                      })
      configuration];
    };
  };
}

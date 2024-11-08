{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
		neovim
		php
		deno
		git-lfs
		lazygit
		neovim
        ];

	homebrew = {
		enable = true;
		brews = [
			"mas"
			"openjdk"
			"composer"
			"jupyterlab"
			"pyenv"
			"pipx"
		];
		casks = [
			"arc"
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
		];
		onActivation.autoUpdate = true;
		onActivation.upgrade = true;
	};

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Bass-MacBook-Pro
    darwinConfigurations."book" = nix-darwin.lib.darwinSystem {
      modules = [ 
      configuration 
      nix-homebrew.darwinModules.nix-homebrew
      {
      	nix-homebrew = {
        	# Install Homebrew under the default prefix
        	enable = true;

        	# Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
		enableRosetta = true;

        	# User owning the Homebrew prefix
        	user = "bazottie";

        	# Automatically migrate existing Homebrew installations
        	autoMigrate = true;
		};
	}
	];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."book".pkgs;
  };
}

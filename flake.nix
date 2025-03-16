{
  description = "Justin's nix config";

  inputs = {
    # ==== Core ====

    # Main package repository
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixOS-esque configuration for Darwin (MacOS)
    nix-darwin = {
      # url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-esque configuration of home directories
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Programs ====

    # `nix-darwin` module to manage a homebrew installation
    # (`nix-darwin` can manage packages/casks from homebrew OOTB,
    #  but doesn't have support for installing homebrew itself)
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    # Provides tools for customizing the look and feel of Spotify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Homebrew taps ====

    # Base taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };

    # Provides `vault` on darwin, as building it takes forever.
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };

    # Provides 'cone' command line for SSO
    homebrew-cone = {
      url = "github:conductorone/homebrew-cone";
      flake = false;
    };

    # Includes `jet`, like `jq` for EDN
    # TODO: write/upstream a derivation to do this through nix,
    # no fundamental reason this needs to come through homebrew
    homebrew-borkdude = {
      url = "github:borkdude/homebrew-brew";
      flake = false;
    };

    # Provides aerospace tiling window manager
    homebrew-nikitabobko = {
      # Contains aerospace
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;

    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = lib.genAttrs supportedSystems;

    overlays = [
      (import ./pkgs)
    ];

    mkDarwinConfiguration = import ./modules/darwin {inherit inputs overlays;};
    mkNixosConfiguration = import ./modules/nixos {inherit inputs overlays;};
  in {
    devShell = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.sops pkgs.nixd pkgs.alejandra];
      };
    });

    overlays.default = import ./pkgs;

    darwinConfigurations = {
      wrath = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "wrath";
        modules = [./hosts/wrath];
      };
      greed = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "greed";
        modules = [./hosts/greed];
      };
    };
  };
}

{
  description = "Justin's nix config";

  nixConfig = {
    substitutors = [
      "https://sonntag.cachix.org"
    ];
    trusted-public-keys = [
      "sonntag.cachix.org-1:4rHXwjmC/EpRwVkCyH0xLQaoeZT9C0oq8TINGSap1Wk="
    ];
  };

  inputs = {
    # ==== Core ====

    # Main package repository
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # NixOS-esque configuration for Darwin (MacOS)
    nix-darwin = {
      # url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-esque configuration of home directories
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amperity.url = ./flakes/amperity;

    # ==== Deploy ====

    # Secrets decrypted at runtime, for NixOS/nix-darwin and home-manager
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Programs ====

    # `nix-darwin` module to manage a homebrew installation
    # (`nix-darwin` can manage packages/casks from homebrew OOTB,
    #  but doesn't have support for installing homebrew itself)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Provides tools for customizing the look and feel of Spotify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "path:./flakes/nixvim";
    nvim.url = "github:sonntag/nvim";

    # tmux-sessionx.url = "github:omerxx/tmux-sessionx";

    # ==== Homebrew taps ====

    # Base taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
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
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    # inherit (nixpkgs) lib;
    # supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    # forAllSystems = lib.genAttrs supportedSystems;
    overlays = [
      (import ./pkgs)
    ];

    pkgs = nixpkgs.legacyPackages.aarch64-darwin;

    mkDarwinConfiguration = import ./modules/darwin {inherit inputs overlays;};
    # mkNixosConfiguration = import ./modules/nixos {inherit inputs overlays;};
  in {
    devShell.aarch64-darwin = pkgs.mkShell {
      packages = with pkgs; [
        sops
        age
      ];
    };

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
        modules = [
          ./hosts/greed
          inputs.amperity.darwinModules
        ];
      };
    };
  };
}

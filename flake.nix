{
  description = "Justin's nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin related stuff
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    # Homebrew taps
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
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    homebrew-cone = {
      url = "github:conductorone/homebrew-cone";
      flake = false;
    };
    homebrew-borkdude = {
      url = "github:borkdude/homebrew-brew";
      flake = false;
    };
    homebrew-nikitabobko = {
      # Contains aerospace
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    tmux-sessionx.url = "github:omerxx/tmux-sessionx";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # greedInfo = {
    #   user = "justin";
    #   system = "aarch64-darwin";
    #   fullUser = "Justin Sonntag";
    #   email = "sonntag@amperity.com";
    #   nixConfigDirectory = "/Users/justin/.config/nix";
    # };
  in {
    devShell = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.sops pkgs.nixd pkgs.alejandra];
      };
    });

    overlays = {
      "aarch64-darwin" = {
        default = import ./pkgs;
      };
      "x86_64-linux" = {
        default = final: prev: prev;
      };
    };

    darwinConfigurations = {
      greed = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "greed";
        modules = [./hosts/greed];
      };
      wrath = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "wrath";
        modules = [./hosts/wrath];
      };
    };
  };
}

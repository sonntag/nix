{
  description = "Justin's nix config";

  inputs = {
    # ==== Core ====

    # Main package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      # inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nix.inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";
    flake-aspects.url = "github:vic/flake-aspects";
    den.url = "github:vic/den";

    # NixOS-esque configuration for Darwin (MacOS)
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-esque configuration of home directories
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-custom-pkgs = {
      url = "github:sonntag/nix-custom-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ==== Deploy ====

    # Secrets decrypted at runtime, for NixOS/nix-darwin and home-manager
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comin = {
      url = "github:nlewo/comin";
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

    nvim = {
      url = "github:sonntag/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # Provides 'cmux' terminal app
    cmux = {
      url = "github:manaflow-ai/cmux";
      flake = false;
    };

    # provides tuna
    homebrew-mikker = {
      url = "github:mikker/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;
    # inherit (nixpkgs) lib;
    # supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    # forAllSystems = lib.genAttrs supportedSystems;

    pkgs = nixpkgs.legacyPackages.aarch64-darwin;

    mkDarwinConfiguration = import ./modules/_darwin {inherit inputs;};

    den =
      (inputs.nixpkgs.lib.evalModules {
        modules = [(inputs.import-tree ./modules)];
        specialArgs.inputs = inputs;
      }).config;
    inherit (den.den.hosts.aarch64-darwin) wrath greed;
  in {
    devShell.aarch64-darwin = pkgs.mkShell {
      packages = with pkgs; [
        sops
        age
      ];
    };

    darwinConfigurations = {
      wrath = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "wrath";
        modules = [
          ./hosts/wrath
          wrath.mainModule
        ];
      };
      greed = mkDarwinConfiguration {
        hostPlatform = "aarch64-darwin";
        system = "aarch64-darwin";
        hostName = "greed";
        modules = [
          ./hosts/greed
          greed.mainModule
        ];
      };
    };
  };
}

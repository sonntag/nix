{
  description = "Justin's nix config";

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # NixOS-esque configuration for Darwin (MacOS)
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-esque configuration of home directories
    home-manager = {
      url = "github:nix-community/home-manager";
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

    # Run Ansible playbooks defined in Nix, for imperative configuration
    # that doesn't fit the declarative nix-darwin/home-manager model.
    nixible = {
      url = "gitlab:TECHNOFAB/nixible?dir=lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

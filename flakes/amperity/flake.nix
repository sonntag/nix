{
  description = "Amperity dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs) nixpkgs;

    # Assuming all dev laptops on Apple Silicon MacBook Pros
    pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  in {
    darwinModules = import ./modules;
  };
}

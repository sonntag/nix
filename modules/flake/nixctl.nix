{...}: {
  perSystem = {pkgs, ...}: let
    nixctl = pkgs.callPackage ../../pkgs/nixctl.nix {};
  in {
    packages.nixctl = nixctl;
    apps.nixctl = {
      type = "app";
      program = "${nixctl}/bin/nixctl";
      meta.description = "Manage and set up Sonntag Nix configurations";
    };
  };
}

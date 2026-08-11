{
  den.aspects.justin.homeManager = {
    config,
    pkgs,
    ...
  }: let
    nixConfigDirectory = "${config.home.homeDirectory}/.local/share/sonntag-nix";

    drb = pkgs.writeShellScriptBin "drb" ''
      exec darwin-rebuild build --flake "${nixConfigDirectory}" "$@"
    '';

    drs = pkgs.writeShellScriptBin "drs" ''
      set -o pipefail
      sudo darwin-rebuild switch --flake "${nixConfigDirectory}" "$@" |& ${pkgs.nix-output-monitor}/bin/nom
    '';

    flakeup = pkgs.writeShellScriptBin "flakeup" ''
      exec nix flake update --flake "${nixConfigDirectory}" "$@"
    '';
  in {
    home.packages = [
      drb
      drs
      flakeup
    ];
  };
}

{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.sonntag.system.auto-update;
in {
  options.sonntag.system.auto-update.enable = mkEnableOption "auto-update";
  config.nix.package = inputs.determinate.inputs.nix.packages.aarch64-darwin.default;
  config.services.comin = {
    inherit (cfg) enable;
    remotes = [
      {
        name = "origin";
        url = "github:sonntag/nix";
        branches.main.name = "main";
      }
    ];
  };
}

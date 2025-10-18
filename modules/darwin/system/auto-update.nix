{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.system.auto-update;
in {
  options.sonntag.system.auto-update.enable = mkEnableOption "auto-update";
  config.services.comin = {
    inherit (cfg) enable;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/sonntag/nix.git";
        branches.main.name = "main";
      }
    ];
  };
}

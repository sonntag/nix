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
      {
        name = "local";
        # TODO: Pull this from a common config
        url = "/Users/justin/Development/sonntag/nix";
        poller.period = 2;
      }
    ];
  };
}

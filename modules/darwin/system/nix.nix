{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.darwin.nix;
in {
  options.sonntag.darwin.nix = {
    enable = mkEnableOption "nix management";
    trusted-users = mkOption {
      description = "Nix trusted users";
      default = ["justin"];
      type = types.listOf types.str;
    };
  };
  config.nix = {
    inherit (cfg) enable;
    package = mkIf cfg.enable pkgs.lix;
    settings = mkIf cfg.enable {
      inherit (cfg) trusted-users;
      substituters = [
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

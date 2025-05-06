{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.most;
in {
  options = {
    sonntag.programs.most = {
      enable = mkEnableOption "most pager";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      most
    ];
  };
}

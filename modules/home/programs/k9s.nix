{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.k9s;
  rose-pine-skins = pkgs.fetchFromGitHub {
    owner = "sasoria";
    repo = "k9s-theme";
    rev = "22cfbb26100d3b411f20fafe870e8b3486b9f006";
    hash = "sha256-n9fXr2M+ygrJhTAQnCWhtByf4MBGvR1LPuF5JDmFkbM=";
  };
in {
  options = {
    sonntag.programs.k9s.enable = mkEnableOption "k9s";
  };

  config = mkIf cfg.enable {
    programs.k9s = {
      enable = true;
      skins = {
        rose-pine = "${rose-pine-skins}/rose-pine.yaml";
      };
      settings.ui.skin = "rose-pine";
    };
  };
}

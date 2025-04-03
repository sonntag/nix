{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.nvim;
in {
  options = {
    sonntag.programs.nvim.enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.file."./.config/nvim/" = {
      source = ./config;
      recursive = true;
    };
  };
}

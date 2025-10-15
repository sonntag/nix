{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.nvim-old;
in {
  options = {
    sonntag.programs.nvim-old.enable = mkEnableOption "nvim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      neovim
    ];

    home.file."./.config/nvim/" = {
      source = ./config;
      recursive = true;
    };
  };
}

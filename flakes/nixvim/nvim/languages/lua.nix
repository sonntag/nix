{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins.conform-nvim.settings = {
    formatters = {
      stylua.command = getExe pkgs.stylua;
    };

    formatters_by_ft = {
      lua = ["stylua"];
    };
  };
}

{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins.conform-nvim.settings = {
    formatters = {
      rustfmt.command = getExe pkgs.rustfmt;
      cljstyle.command = getExe pkgs.cljstyle;
    };

    formatters_by_ft = {
      rust = ["rustfmt"];
    };
  };
}

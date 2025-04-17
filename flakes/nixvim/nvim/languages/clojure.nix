{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins.conform-nvim.settings = {
    formatters = {
      cljstyle.command = getExe pkgs.cljstyle;
    };

    formatters_by_ft = {
      clojure = ["cljstyle"];
    };
  };
}

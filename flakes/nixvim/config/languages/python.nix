{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins.conform-nvim.settings = {
    formatters = {
      ruff_fix.command = getExe pkgs.ruff;
      ruff_format.command = getExe pkgs.ruff;
      ruff_organize_imports.command = getExe pkgs.ruff;
    };

    formatters_by_ft = {
      python = [
        "ruff_fix"
        "ruff_format"
        "ruff_organize_imports"
      ];
    };
  };
}

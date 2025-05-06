{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.sonntag.diagnostics.icons;
in {
  options.sonntag.diagnostics.icons = {
    error = mkOption {
      type = types.str;
      default = "";
      description = ''
        Icon to use for the error diagnostic sign.
      '';
    };
    warn = mkOption {
      type = types.str;
      default = "";
      description = ''
        Icon to use for the warn diagnostic sign.
      '';
    };

    hint = mkOption {
      type = types.str;
      default = "";
      description = ''
        Icon to use for the hint diagnostic sign.
      '';
    };
    info = mkOption {
      type = types.str;
      default = "";
      description = ''
        Icon to use for the info diagnostic sign.
      '';
    };
  };

  config = {
    diagnostic.settings = {
      virtual_lines = true;
      signs.text = lib.nixvim.toRawKeys {
        "vim.diagnostic.severity.ERROR" = cfg.error;
        "vim.diagnostic.severity.WARN" = cfg.warn;
        "vim.diagnostic.severity.HINT" = cfg.hint;
        "vim.diagnostic.severity.INFO" = cfg.info;
      };
    };
  };
}

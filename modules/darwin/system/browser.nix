{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.system.browser;
in {
  options = {
    system.browser.default = mkOption {
      type = types.nullOr types.str;
      default = "browser";
      description = ''
        Name of the browser to set as the default.
      '';
    };
  };

  config = mkIf (cfg.default != null) {
    system.activationScripts.postUserActivation.text = ''
      echo >&2 "Setting default browser to ${cfg.default}..."
      ${pkgs.defaultbrowser}/bin/defaultbrowser ${cfg.default}
      echo >&2 "Default browser set."
    '';
  };
}

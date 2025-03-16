{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  options = {
    system.wallpaper.image.path = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an image to use as the wallpaper. The default is null.
      '';
    };
  };

  config = {
    system.activationScripts.postUserActivation.text = mkIf (config.system.wallpaper.image.path != null) ''
      echo >&2 "Setting wallpaper image..."
      echo >&2 "Setting wallpaper to ${config.system.wallpaper.image.path}"
      ${pkgs.desktoppr}/bin/desktoppr ${config.system.wallpaper.image.path}
      echo >&2 "Wallpaper setup complete."
    '';
  };
}

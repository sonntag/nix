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
      default = ../../../backgrounds/rancho-cucamonga-tree.png;
      description = ''
        Path to an image to use as the wallpaper. The default is null.
      '';
    };
  };

  config = mkIf (config.system.wallpaper.image.path != null) {
    system.activationScripts.postUserActivation.text = ''
      echo >&2 "Setting wallpaper image..."
      echo >&2 "Setting wallpaper to ${config.system.wallpaper.image.path}"
      ${pkgs.desktoppr}/bin/desktoppr ${config.system.wallpaper.image.path}
      echo >&2 "Wallpaper setup complete."
    '';
  };
}

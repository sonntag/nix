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
    launchd.enable = true;
    launchd.agents.set-wallpaper = {
      enable = true;
      config = {
        Label = "com.sonntag.set-wallpaper";
        ProgramArguments = [
          "${pkgs.desktoppr}/bin/desktoppr"
          "${config.system.wallpaper.image.path}"
        ];
        RunAtLoad = true;
        KeepAlive = false;
        StandardErrorPath = "/Users/justin/Library/Logs/set-wallpaper/set-wallpaper.err.log";
        StandardOutPath = "/Users/justin/Library/Logs/set-wallpaper/set-wallpaper.out.log";
      };
    };
  };
}

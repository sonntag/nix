{
  den.default.homeManager = {
    lib,
    pkgs,
    config,
    ...
  }:
    with lib; {
      options = {
        sonntag.wallpaper.image.path = mkOption {
          type = types.nullOr types.path;
          description = ''
            Path to an image to use as the wallpaper. The default is null.
          '';
        };
      };

      config = mkIf (config.sonntag.wallpaper.image.path != null) {
        launchd.enable = true;
        launchd.agents.desktoppr = {
          enable = true;
          config = {
            Label = "com.sonntag.desktoppr";
            ProgramArguments = [
              "${pkgs.desktoppr}/bin/desktoppr"
              "${config.sonntag.wallpaper.image.path}"
            ];
            RunAtLoad = true;
            KeepAlive = false;
            StandardErrorPath = "/Users/justin/Library/Logs/desktoppr/desktoppr.err.log";
            StandardOutPath = "/Users/justin/Library/Logs/desktoppr/desktoppr.out.log";
          };
        };
      };
    };
}

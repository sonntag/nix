{
  lib,
  pkgs,
  ...
}: {
  services.sketchybar = {
    enable = true;
    extraPackages = with pkgs; [
      coreutils
      curl
      gh
      gh-notify
      gnugrep
      gnused
      jankyborders
      jq
      lua5_4
      wttrbar
      sketchyhelper
      dynamic-island-helper
    ];
  };

  launchd.user.agents.sketchybar.serviceConfig = {
    StandardErrorPath = "/Users/justin/library/Logs/sketchybar/sketchybar.err.log";
    StandardOutPath = "/Users/justin/library/Logs/sketchybar/sketchybar.out.log";
    KeepAlive = lib.mkForce {
      PathState = {
        "/run/current-system/sw/bin/sketchybar" = true;
      };
    };
  };
}

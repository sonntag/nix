{
  lib,
  pkgs,
  ...
}:
with lib; let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs.ghostty = {
    enable = true;
    # Ghostty is installed via homebrew on mac
    package = mkIf isDarwin null;
    settings = {
      font-family = "VictorMono Nerd Font Mono";
      font-size = 13;
      font-thicken = true;

      theme = "rose-pine";
      custom-shader = "${./shaders/cursor-blaze.glsl}";

      macos-titlebar-style = "hidden";
      window-colorspace = "display-p3";
      window-padding-x = 5;
      window-padding-y = 5;
      window-padding-balance = true;
      quit-after-last-window-closed = true;
    };
  };
}

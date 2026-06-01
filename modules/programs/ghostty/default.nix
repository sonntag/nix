{
  den.default.darwin.homebrew.casks = ["ghostty"];
  den.aspects.justin.homeManager = {
    lib,
    pkgs,
    ...
  }:
    with lib; let
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    in {
      # On Linux (e.g. SSH targets) we don't want the GUI app, just the
      # terminfo entry so tmux/etc. accept TERM=xterm-ghostty.
      home.packages = mkIf (!isDarwin) [pkgs.ghostty.terminfo];

      programs.ghostty = {
        # The GUI app and its settings only make sense on Darwin.
        enable = isDarwin;
        # Ghostty is installed via homebrew on mac
        package = mkIf isDarwin null;
        settings = {
          font-family = "VictorMono Nerd Font Mono";
          font-size = 13;
          font-thicken = true;

          theme = "Rose Pine";
          custom-shader = "${./shaders/cursor-blaze.glsl}";

          confirm-close-surface = false;
          macos-titlebar-style = "hidden";
          window-colorspace = "display-p3";
          window-padding-x = 5;
          window-padding-y = 5;
          window-padding-balance = true;
          quit-after-last-window-closed = true;
        };
      };
    };
}

{
  den.default.darwin.homebrew.casks = ["ghostty"];
  den.aspects.justin.homeManager = {
    lib,
    pkgs,
    config,
    ...
  }:
    with lib; let
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    in {
      # On Linux (e.g. SSH targets) we don't want the GUI app, just the
      # terminfo entry so tmux/etc. accept TERM=xterm-ghostty.
      home.packages = mkIf (!isDarwin) [pkgs.ghostty.terminfo];

      # home-manager doesn't set TERMINFO_DIRS on a standalone (non-NixOS)
      # install, so ncurses never finds terminfo entries in the profile.
      # Point it at the profile's terminfo dir; the trailing empty entry
      # keeps ncurses' compiled-in default locations on the search path.
      home.sessionVariables.TERMINFO_DIRS =
        mkIf (!isDarwin) "${config.home.profileDirectory}/share/terminfo:";

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

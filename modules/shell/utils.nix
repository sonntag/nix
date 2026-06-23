{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      # GNU coreutils. We want GNU userland as the default for Linux-consistent
      # behavior. On macOS only, strip out `stty`: GNU `stty` is built around
      # Linux termios and misbehaves against macOS's tty driver (it fails with
      # "unable to perform all requested operations"). `stty` controls the actual
      # terminal device, which is inherently OS-specific, so on Darwin the native
      # /bin/stty is the one we want — removing GNU's lets /bin/stty win on PATH
      # again, which keeps interactive installers that put the terminal into raw
      # mode (e.g. `curl … | sh` key-press menus) working. On Linux the system
      # stty is already GNU and works fine, so we keep the full package there.
      (
        if stdenv.isDarwin
        then
          symlinkJoin {
            name = "coreutils-no-stty";
            paths = [coreutils];
            postBuild = "rm -f $out/bin/stty";
          }
        else coreutils
      )
      devenv
      eza
      fd
      gh
      gnused
      htop
      httpie
      jq
      mdts
      fastfetch
      nerd-fonts.victor-mono
      nps
      # ov
      ripgrep
      tldr
      tree
      yazi
    ];

    # Enable carapace completions
    programs.carapace.enable = true;
    programs.zoxide.enable = true;

    home.sessionVariables = {
      CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";
    };
  };
}

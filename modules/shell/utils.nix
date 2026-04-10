{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      coreutils
      devenv
      eza
      fd
      gh
      gnused
      htop
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
  };
}

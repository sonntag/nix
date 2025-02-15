{pkgs, ...}: {
  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./shell/tmux.nix
    ./shell/fish/default.nix
    ./shell/starship
    # ./user/apps/miscellaneous/spicetify.nix
  ];

  # Enable carapace completions
  programs.carapace.enable = true;

  programs.git.enable = true;

  # Used for Amperity development
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  programs.bat.themes = {
    rose-pine = {
      src = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "tm-theme"; # Bat uses sublime syntax for its themes
        rev = "45061dc3fda6bd2126305df8fd6c81ef5a0f9c27";
        sha256 = "sha256-N68TUiNQkyVdgEFQ4EH1PpSAjHCsavha7moXHUg89/w=";
      };
      file = "dist/themes/rose-pine.tmTheme";
    };
  };

  programs.bat.config.theme = "rose-pine";
  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    colors = {
      "fg" = "#908caa";
      "bg" = "#191724";
      "hl" = "#ebbcba";
      "fg+" = "#e0def4";
      "bg+" = "#26233a";
      "hl+" = "#ebbcba";
      "border" = "#403d52";
      "header" = "#31748f";
      "gutter" = "#191724";
      "spinner" = "#f6c177";
      "info" = "#9ccfd8";
      "pointer" = "#c4a7e7";
      "marker" = "#eb6f92";
      "prompt" = "#908caa";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";

    # Amperity related
    VAULT_ADDR = "https://vault.amperity.top:8200";
  };

  home.sessionPath = [
    "$HOME/Development/amperity/app/bin"
  ];

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };

  home.file."./.config/aerospace/" = {
    source = ./aerospace;
    recursive = true;
  };

  home.file."./.config/kanata/" = {
    source = ./kanata;
    recursive = true;
  };

  home.file."./.config/ghostty/config" = {
    source = ./modules/darwin/programs/ghostty/config;
  };

  home.file.".gitconfig" = {
    source = ./gitconfig;
  };

  home.file.".dircolors" = {
    source = ./dircolors;
  };
}

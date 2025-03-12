{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config.theme = "rose-pine";
    themes = {
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
  };
}

{
  imports = [
    ./darwin
    ./programs
    ./secrets.nix
    ./services
    ./ssh
  ];

  home.stateVersion = "24.05";

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";
  };

  fonts.fontconfig.enable = true;

  # home.file.".dircolors" = {
  #   source = ./dircolors;
  # };
}

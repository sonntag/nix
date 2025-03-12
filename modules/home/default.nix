{...}: {
  imports = [
    ./programs
  ];

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";

    # Amperity related
    VAULT_ADDR = "https://vault.amperity.top:8200";
  };

  home.sessionPath = [
    "$HOME/Development/amperity/app/bin"
  ];

  # home.file.".dircolors" = {
  #   source = ./dircolors;
  # };
}

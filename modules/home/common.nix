{pkgs, ...}: {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    source-code-pro
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ./programs/tmux
    ./programs/zsh
    ./programs/nvim
  ];
}

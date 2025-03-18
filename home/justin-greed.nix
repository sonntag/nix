{pkgs, ...}: {
  home.stateVersion = "24.05";

  imports = [
    ../modules/home
  ];

  home.packages = with pkgs; [
    alejandra # nix formatter
    awscli2
    cljstyle
    clojure
    clojure-lsp
    coreutils
    difftastic
    direnv
    eza
    fd
    figlet
    gnused
    htop
    httpie
    jq
    just
    k9s
    kubectx
    kubelogin # for azure
    lazydocker
    lazygit
    leiningen
    nb
    neil
    neofetch
    neovim
    nerd-fonts.victor-mono
    nodejs
    presenterm
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  fonts.fontconfig.enable = true;

  # Used for Amperity development
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };
}

{pkgs, ...}: {
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    alejandra # nix formatter
    awscli2
    clojure
    clojure-lsp
    coreutils
    difftastic
    direnv
    eza
    fd
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
    nerdfonts
    nodejs
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home
  ];
}

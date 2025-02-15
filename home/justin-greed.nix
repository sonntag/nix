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
    spotify
    tldr
    tree
    vault
    yazi
    zoxide
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../old.nix
    # ../modules/home/services/syncthing.nix
    # ../modules/home/programs/git/work.nix
    # ../modules/home/programs/kitty.nix
    # ../modules/home/programs/nvim
    # ../modules/home/programs/emacs
    # ../modules/home/programs/zsh
    # ../modules/home/programs/zsh/darwin.nix
    # ../modules/home/programs/zsh/work.nix
  ];
}

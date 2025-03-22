{pkgs, ...}: {
  imports = [
    ./aerospace
    ./fish
    ./ghostty
    ./git
    ./nvim
    ./starship
    ./bat.nix
    ./fzf.nix
    ./man.nix
    ./spotify.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    alejandra # nix formatter
    coreutils
    difftastic
    eza
    fd
    figlet
    gnused
    htop
    jq
    just
    lazygit
    most
    neofetch
    neovim
    nerd-fonts.victor-mono
    presenterm
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  # Enable carapace completions
  programs.carapace.enable = true;
}

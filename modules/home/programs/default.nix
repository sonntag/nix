{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./claude-code.nix
    ./fish
    ./fzf.nix
    ./ghostty
    ./git
    ./lazygit.nix
    ./man.nix
    ./nixvim.nix
    ./nvim
    ./spotify.nix
    ./starship
    ./tmux.nix
    ./zoxide.nix
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
    most
    neofetch
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

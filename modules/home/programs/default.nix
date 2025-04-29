{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./claude-code.nix
    ./direnv.nix
    ./fish
    ./fzf.nix
    ./ghostty
    ./git.nix
    ./lazygit.nix
    ./man.nix
    ./nixvim.nix
    ./nvim
    ./sketchybar
    ./spotify.nix
    ./starship
    ./tmux.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    coreutils
    devenv
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

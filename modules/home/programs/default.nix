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
    ./most.nix
    ./nixvim.nix
    ./nvim
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
    jujutsu
    just
    neofetch
    nerd-fonts.victor-mono
    ov
    presenterm
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  # Enable carapace completions
  programs.carapace.enable = true;

  programs.kakoune.enable = true;

  sonntag.programs.most.enable = true;
}

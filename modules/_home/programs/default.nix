{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./claude-code
    ./codex
    ./difftastic.nix
    ./direnv.nix
    ./fish
    ./fzf.nix
    ./git.nix
    ./jj.nix
    ./k9s.nix
    ./lazygit.nix
    ./man.nix
    ./most.nix
    ./nvim.nix
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
    gh
    gnused
    htop
    jq
    mdts
    fastfetch
    nerd-fonts.victor-mono
    nps
    ov
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  # Enable carapace completions
  programs.carapace.enable = true;
}

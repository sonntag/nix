{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./claude-code
    ./codex
    ./difftastic.nix
    ./direnv.nix
    ./fabric.nix
    ./fish
    ./fzf.nix
    ./ghostty
    ./git.nix
    ./jj.nix
    ./k9s.nix
    ./lazygit.nix
    ./man.nix
    ./mcp
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
    # figlet
    gh
    gnused
    htop
    jq
    # just
    lazyjj
    mdts
    neofetch
    nerd-fonts.victor-mono
    nps
    ov
    # presenterm
    ripgrep
    tldr
    tree
    yazi
    zoxide
  ];

  # Enable carapace completions
  programs.carapace.enable = true;
}

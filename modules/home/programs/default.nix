{pkgs, ...}: {
  imports = [
    ./bat.nix
    ./claude-code.nix
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
    gnused
    htop
    jq
    # just
    lazyjj
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

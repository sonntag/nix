{pkgs, ...}: {
  imports = [
    ./aerospace
    ./fish
    ./ghostty
    ./git
    ./kanata
    ./nvim
    ./starship
    ./bat.nix
    ./fzf.nix
    ./spotify.nix
    ./tmux.nix
  ];

  # Enable carapace completions
  programs.carapace.enable = true;

  # Used for Amperity development
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };
}

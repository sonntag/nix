{
  imports = [
    ./aerospace
    ./fish
    ./ghostty
    ./git
    ./nvim
    ./starship
    ./bat.nix
    ./fzf.nix
    ./spotify.nix
    ./tmux.nix
  ];

  # Enable carapace completions
  programs.carapace.enable = true;
}

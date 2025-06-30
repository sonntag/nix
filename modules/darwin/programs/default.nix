{
  imports = [
    ./casks.nix
    ./goose.nix
    ./mas.nix
    ./personal-casks.nix
  ];
  programs.fish.enable = true;
  # TODO: what does this do?
  # programs.fish.useBabelfish = true;
}

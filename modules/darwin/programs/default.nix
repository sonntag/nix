{
  imports = [
    ./casks.nix
    ./goose.nix
    ./mas.nix
    ./personal-casks.nix
  ];
  programs.fish.enable = true;
  programs.fish.babelfishPackage = true;
}

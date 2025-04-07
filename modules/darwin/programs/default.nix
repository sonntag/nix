{
  imports = [
    ./casks.nix
    # TODO: this keeps reinstalling all mas apps
    # ./mas.nix
    ./personal-casks.nix
  ];
  programs.fish.enable = true;
  programs.fish.babelfishPackage = true;
}

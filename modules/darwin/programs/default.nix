{
  imports = [
    ./casks.nix
    # TODO: this keeps reinstalling all mas apps because of a bug in mas
    # detecting the current installed apps:
    # https://github.com/mas-cli/mas/issues/724
    # https://github.com/mas-cli/mas/issues/728
    # ./mas.nix
    ./personal-casks.nix
  ];
  programs.fish.enable = true;
  programs.fish.babelfishPackage = true;
}

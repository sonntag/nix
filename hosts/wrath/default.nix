{
  nix.enable = false;

  system.stateVersion = 6;

  imports = [
    ./users.nix
    ./dock.nix
  ];
}

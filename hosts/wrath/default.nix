{
  nix.enable = false;

  imports = [
    ./users.nix
    ./dock.nix
  ];
}

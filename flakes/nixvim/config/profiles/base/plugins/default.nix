{
  imports = [
    ./cursorline.nix
    ./which-key.nix
  ];
  plugins = {
    sleuth.enable = true;
    web-devicons.enable = true;
  };
}

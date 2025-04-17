{
  imports = [
    ./oil.nix
  ];

  plugins = {
    bufferline.enable = true;
    lualine.enable = true;
    web-devicons.enable = true;
    snacks.enable = true;
  };
}

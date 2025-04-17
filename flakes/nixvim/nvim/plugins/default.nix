{
  imports = [
    ./conform.nix
    ./cursorline.nix
    ./lazygit.nix
    ./oil.nix
    ./which-key.nix
  ];

  plugins = {
    lualine.enable = true;
    lz-n.enable = true;
    snacks.enable = true;
    web-devicons.enable = true;
  };
}

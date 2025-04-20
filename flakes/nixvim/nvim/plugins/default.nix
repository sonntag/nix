{pkgs, ...}: {
  imports = [
    ./conform.nix
    ./cursorline.nix
    ./oil.nix
    ./which-key.nix
  ];

  plugins = {
    lualine.enable = true;
    lz-n.enable = true;
    sleuth.enable = true;
    snacks.enable = true;
    web-devicons.enable = true;
  };

  extraPlugins = [
    pkgs.vimPlugins.tabout-nvim
  ];

  extraConfigLua = "require('tabout').setup({})";
}

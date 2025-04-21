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
    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {};
    };
    sleuth.enable = true;
    snacks.enable = true;
    tmux-navigator.enable = true;
  };

  extraPlugins = [
    pkgs.vimPlugins.tabout-nvim
  ];

  extraConfigLua = "require('tabout').setup({})";
}

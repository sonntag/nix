{
  imports = [
    ./auto-save.nix
    ./conform.nix
    ./cursorline.nix
    ./mini-keymap.nix
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

  # extraPlugins = with pkgs.vimPlugins; [
  #   tabout-nvim
  # ];

  # extraConfigLua = ''
  #   require("tabout").setup({
  #     act_as_tab = false,
  #     ignore_beginning = true,
  #     tabkey = "",
  #     backwards_tabkey = ""
  #   })
  # '';
}

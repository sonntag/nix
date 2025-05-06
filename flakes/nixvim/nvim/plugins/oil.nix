{
  pkgs,
  util,
  ...
}: let
  inherit (util) keymap;
in {
  plugins.oil = {
    enable = true;
    settings = {
      keymaps = {
        # setting to false disables the keybindings. Disabling these allows me to still use
        # Tmux navigations with Oil open.
        "<C-s>" = false;
        "<C-h>" = false;
        "<C-t>" = false;
        "<C-l>" = false;
        # Refresh was originally bound to <C-l> so rebinding it since it's actually useful
        "<C-r>" = "actions.refresh";
      };
      win_options.signcolumn = "yes:2";
    };

    luaConfig.post = ''
      require("oil-git-status").setup();
    '';
  };

  keymaps = [
    (keymap "-" "<cmd>Oil<cr>" "Open parent directory")
  ];

  extraPlugins = with pkgs.vimPlugins; [
    # https://github.com/refractalize/oil-git-status.nvim
    oil-git-status-nvim
  ];
}

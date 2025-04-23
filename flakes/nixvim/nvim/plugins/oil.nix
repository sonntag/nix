{util, ...}: let
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
    };
  };
  keymaps = [
    (keymap "-" "<cmd>Oil<cr>" "Open parent directory")
  ];
}

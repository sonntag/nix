{util, ...}: let
  inherit (util) keymapLua;
in {
  keymaps = [
    (keymapLua "<leader>gB" "Snacks.gitbrowse()" "Git Browse")
    (keymapLua "<leader>gg" "Snacks.lazygit()" "Lazygit")
  ];

  plugins.gitsigns = {
    enable = true;
  };

  # TODO: add git signs
}

{util, ...}: let
  inherit (util) keymap;
in {
  plugins.dropbar.enable = true;
  keymaps = [
    (keymap "<leader>wh" "<c-w>s" "Split Window Below")
    (keymap "<leader>wv" "<c-w>v" "Split Window Vertically")
    (keymap "<leader>wd" "<c-w>c" "Delete Window")
  ];
}

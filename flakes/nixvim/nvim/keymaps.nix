{util, ...}: let
  inherit (util) keymap;
in {
  keymaps = [
    (keymap "n" "<esc>" "<cmd>nohlsearch<cr>" "")

    (keymap "n" "<left>" "<cmd>echo 'Use h to move!!'<cr>" "")
    (keymap "n" "<right>" "<cmd>echo 'Use l to move!!'<cr>" "")
    (keymap "n" "<up>" "<cmd>echo 'Use k to move!!'<cr>" "")
    (keymap "n" "<down>" "<cmd>echo 'Use j to move!!'<cr>" "")

    (keymap ["i" "x" "n" "s"] "<C-s>" "<cmd>w<cr><esc>" "Save File")
  ];
}

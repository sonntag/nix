{util, ...}: let
  inherit (util) keymap;
in {
  # TODO: make delete key jump over whitespace
  keymaps = [
    (keymap "<esc>" "<cmd>nohlsearch<cr>" "")

    (keymap "<left>" "<cmd>echo 'Use h to move!!'<cr>" "")
    (keymap "<right>" "<cmd>echo 'Use l to move!!'<cr>" "")
    (keymap "<up>" "<cmd>echo 'Use k to move!!'<cr>" "")
    (keymap "<down>" "<cmd>echo 'Use j to move!!'<cr>" "")

    (keymap "<C-s>" "<cmd>w<cr><esc>" "Save File" // {mode = ["i" "x" "n" "s"];})
  ];
}

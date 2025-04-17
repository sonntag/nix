{util, ...}: {
  keymaps = [
    (util.keymap "n" "<esc>" "<cmd>nohlsearch<cr>" "")

    (util.keymap "n" "<left>" "<cmd>echo 'Use h to move!!'<cr>" "")
    (util.keymap "n" "<right>" "<cmd>echo 'Use l to move!!'<cr>" "")
    (util.keymap "n" "<up>" "<cmd>echo 'Use k to move!!'<cr>" "")
    (util.keymap "n" "<down>" "<cmd>echo 'Use j to move!!'<cr>" "")

    (util.keymap ["i" "x" "n" "s"] "<C-s>" "<cmd>w<cr><esc>" "Save File")
  ];
}

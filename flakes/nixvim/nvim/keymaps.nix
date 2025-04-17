{util, ...}: {
  keymaps = [
    (util.keymap "n" "<Esc>" "<cmd>nohlsearch<CR>" "")

    (util.keymap "n" "<left>" "<cmd>echo 'Use h to move!!'<CR>" "")
    (util.keymap "n" "<right>" "<cmd>echo 'Use l to move!!'<CR>" "")
    (util.keymap "n" "<up>" "<cmd>echo 'Use k to move!!'<CR>" "")
    (util.keymap "n" "<down>" "<cmd>echo 'Use j to move!!'<CR>" "")
  ];
}

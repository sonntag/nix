{util, ...}: let
  inherit (util) nmap keymap keymapLua;
in {
  keymaps = [
    (nmap "<esc>" "<cmd>nohlsearch<cr>")

    (keymap "<left>" "<cmd>echo 'Use h to move!!'<cr>" "Use h to move!!")
    (keymap "<right>" "<cmd>echo 'Use l to move!!'<cr>" "Use l to move!!")
    (keymap "<up>" "<cmd>echo 'Use k to move!!'<cr>" "Use k to move!!")
    (keymap "<down>" "<cmd>echo 'Use j to move!!'<cr>" "Use j to move!!")

    (keymap "<C-s>" "<cmd>w<cr><esc>" "Save File" // {mode = ["i" "x" "n" "s"];})

    (keymap "<leader>qq" "<cmd>qa<cr>" "Quit All")

    # Move cursor to the middle of the screen when paging up or down
    (keymap "<c-u>" "<c-u>zzzv" "Page up")
    (keymap "<c-d>" "<c-d>zzzv" "Page down")

    # Move selection to middle of screen when selecting search results
    (keymap "n" "nzzzv" "Next search result")
    (keymap "N" "Nzzzv" "Prev search result")

    # Line movement improvements
    (keymap "j" "v:count == 0 ? 'gj' : 'j'" "Down"
      // {
        options.expr = true;
        options.silent = true;
      })
    (keymap "k" "v:count == 0 ? 'gk' : 'k'" "Up"
      // {
        options.expr = true;
        options.silent = true;
      })

    # Tab management
    (keymap "<leader>tt" "<cmd>tabnew<cr>" "New Tab")
    (keymap "<leader>td" "<cmd>tabclose<cr>" "Close Tab")
    (keymap "<leader>to" "<cmd>tabonly<cr>" "Close Other Tab")
    (keymap "<leader>tf" "<cmd>tabfirst<cr>" "First Tab")
    (keymap "<leader>tl" "<cmd>tablast<cr>" "Last Tab")
    (keymap "<leader>tn" "<cmd>tabnext<cr>" "Next Tab")
    (keymap "<leader>tp" "<cmd>tabprevious<cr>" "Previous Tab")

    # Window sizes
    (keymap "<C-Up>" "<cmd>resize +2<cr>" "Increase Window Height")
    (keymap "<C-Down>" "<cmd>resize -2<cr>" "Decrease Window Height")
    (keymap "<C-Left>" "<cmd>vertical resize -2<cr>" "Decrease Window Width")
    (keymap "<C-Right>" "<cmd>vertical resize +2<cr>" "Increase Window Width")

    # UI toggles
    (keymap "<leader>ur" "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>"
      "Redraw / Clear hlsearch / Diff Update")

    # If the line is empty, these 4 keymaps will enter insert mode with the proper indentation
    (keymapLua "i" "return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'S' or 'i'"
      "insert"
      // {
        options.expr = true;
        options.noremap = true;
      })
    (keymapLua "I" "return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'S' or 'I'"
      "insert at beginning of line"
      // {
        options.expr = true;
        options.noremap = true;
      })
    (keymapLua "a" "return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'S' or 'a'"
      "append"
      // {
        options.expr = true;
        options.noremap = true;
      })
    (keymapLua "A" "return string.match(vim.api.nvim_get_current_line(), '%g') == nil and 'S' or 'A'"
      "append at end of line"
      // {
        options.expr = true;
        options.noremap = true;
      })
  ];
}

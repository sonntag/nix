{
  config,
  lib,
  util,
  ...
}:
with lib; let
  inherit (util) keymap keymapLua whichkeyGroup;
  cfg = config.sonntag.nvim.layers.buffers;
in {
  options.sonntag.nvim.layers.buffers.enable = mkEnableOption "buffers layer" // {default = true;};

  config = mkIf cfg.enable {
    plugins.bufferline.enable = true;

    plugins.which-key.settings.spec = [
      (whichkeyGroup "<leader>b" "[B]uffer")
    ];

    keymaps = [
      (keymap "n" "<S-h>" "<cmd>bprevious<cr>" "Prev Buffer")
      (keymap "n" "<S-l>" "<cmd>bpnext<cr>" "Next Buffer")

      (keymap "n" "<leader>bb" "<cmd>e #<cr>" "Switch to Other Buffer")

      (keymapLua "n" "<leader>bd" "Snacks.bufdelete()" "[D]elete Buffer")
      (keymapLua "n" "<leader>bo" "Snacks.bufdelete.other()" "Delete [O]ther Buffers")
      (keymap "n" "<leader>bD" "<cmd>:bd<cr>" "Delete Buffer and Window")

      (keymap "n" "<leader>bp" "<Cmd>BufferLineTogglePin<CR>" "Toggle Pin")
      (keymap "n" "<leader>bP" "<Cmd>BufferLineGroupClose ungrouped<CR>" "Delete Non-Pinned Buffers")
      (keymap "n" "<leader>br" "<Cmd>BufferLineCloseRight<CR>" "Delete Buffers to the Right")
      (keymap "n" "<leader>bl" "<Cmd>BufferLineCloseLeft<CR>" "Delete Buffers to the Left")
      (keymap "n" "<S-h>" "<cmd>BufferLineCyclePrev<cr>" "Prev Buffer")
      (keymap "n" "<S-l>" "<cmd>BufferLineCycleNext<cr>" "Next Buffer")
      (keymap "n" "[b" "<cmd>BufferLineMovePrev<cr>" "Move buffer prev")
      (keymap "n" "]b" "<cmd>BufferLineMoveNext<cr>" "Move buffer next")
    ];
  };
}

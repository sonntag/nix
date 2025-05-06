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
      (whichkeyGroup "<leader>b" "buffers")
    ];

    keymaps = [
      (keymap "<S-h>" "<cmd>bprevious<cr>" "Prev Buffer")
      (keymap "<S-l>" "<cmd>bpnext<cr>" "Next Buffer")

      (keymap "<leader>bb" "<cmd>e #<cr>" "Switch to Other Buffer")

      (keymapLua "<leader>bd" "Snacks.bufdelete()" "[D]elete Buffer")
      (keymapLua "<leader>bo" "Snacks.bufdelete.other()" "Delete [O]ther Buffers")
      (keymap "<leader>bD" "<cmd>:bd<cr>" "Delete Buffer and Window")

      (keymap "<leader>bp" "<Cmd>BufferLineTogglePin<CR>" "Toggle Pin")
      (keymap "<leader>bP" "<Cmd>BufferLineGroupClose ungrouped<CR>" "Delete Non-Pinned Buffers")
      (keymap "<leader>br" "<Cmd>BufferLineCloseRight<CR>" "Delete Buffers to the Right")
      (keymap "<leader>bl" "<Cmd>BufferLineCloseLeft<CR>" "Delete Buffers to the Left")
      (keymap "<S-h>" "<cmd>BufferLineCyclePrev<cr>" "Prev Buffer")
      (keymap "<S-l>" "<cmd>BufferLineCycleNext<cr>" "Next Buffer")
      (keymap "[b" "<cmd>BufferLineMovePrev<cr>" "Move buffer prev")
      (keymap "]b" "<cmd>BufferLineMoveNext<cr>" "Move buffer next")
    ];
  };
}

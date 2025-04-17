{
  config,
  lib,
  util,
  ...
}:
with lib; let
  cfg = config.sonntag.nvim.layers.buffers;
in {
  options.sonntag.nvim.layers.buffers.enable = mkEnableOption "buffers layer" // {default = true;};

  config = mkIf cfg.enable {
    plugins.bufferline.enable = true;

    plugins.which-key.settings.spec = [
      (util.whichkeyGroup "<leader>b" "[B]uffer")
    ];

    keymaps = [
      (util.keymap "n" "<S-h>" "<cmd>bprevious<cr>" "Prev Buffer")
      (util.keymap "n" "<S-l>" "<cmd>bpnext<cr>" "Next Buffer")

      (util.keymap "n" "<leader>bb" "<cmd>e #<cr>" "Switch to Other Buffer")

      (util.keymapLua "n" "<leader>bd" "require('snacks').bufdelete()" "[D]elete Buffer")
      (util.keymapLua "n" "<leader>bo" "require('snacks').bufdelete.other()" "Delete [O]ther Buffers")
      (util.keymap "n" "<leader>bD" "<cmd>:bd<cr>" "Delete Buffer and Window")
    ];
  };
}

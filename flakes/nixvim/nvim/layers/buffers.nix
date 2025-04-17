{util, ...}: {
  plugins.bufferline.enable = true;

  plugins.which-key.settings.spec = [
    (util.whichkeyGroup "<leader>b" "[B]uffer")
  ];

  keymaps = [
    (util.keymapLua "n" "<leader>bd" "require('snacks').bufdelete()" "[D]elete Buffer")
    (util.keymapLua "n" "<leader>bo" "require('snacks').bufdelete.other()" "Delete [O]ther Buffers")
  ];
}

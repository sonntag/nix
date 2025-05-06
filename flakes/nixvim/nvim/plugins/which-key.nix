{util, ...}: let
  inherit (util) whichkeyGroup;
in {
  plugins.which-key = {
    enable = true;

    # Document existing key chains
    settings.spec = [
      (whichkeyGroup "<leader>c" "code")
      (whichkeyGroup "<leader>d" "[d]ocument")
      (whichkeyGroup "<leader>f" "find")
      (whichkeyGroup "<leader>g" "git")
      (whichkeyGroup "<leader>h" "git [h]unk" // {mode = ["n" "v"];})
      (whichkeyGroup "<leader>r" "[r]ename")
      (whichkeyGroup "<leader>s" "search")
      (whichkeyGroup "<leader>t" "tabs")
      (whichkeyGroup "<leader>u" "UI")
      (whichkeyGroup "<leader>w" "window")
      (whichkeyGroup "<leader>x" "diagnostics/quickfix")

      (whichkeyGroup "g" "goto/global")
    ];
  };
}

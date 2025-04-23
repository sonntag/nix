{util, ...}: let
  inherit (util) whichkeyGroup;
in {
  plugins.which-key = {
    enable = true;

    # Document existing key chains
    settings.spec = [
      (whichkeyGroup "<leader>c" "[c]ode")
      (whichkeyGroup "<leader>d" "[d]ocument")
      (whichkeyGroup "<leader>r" "[r]ename")
      (whichkeyGroup "<leader>s" "[s]earch")
      (whichkeyGroup "<leader>w" "[w]indow")
      (whichkeyGroup "<leader>t" "[t]oggle")
      (whichkeyGroup "<leader>h" "git [h]unk" // {mode = ["n" "v"];})
      (whichkeyGroup "<leader>g" "git")
      (whichkeyGroup "<leader>f" "find")
      (whichkeyGroup "<leader>x" "diagnostics/quickfix")

      (whichkeyGroup "g" "goto/global")
    ];
  };
}

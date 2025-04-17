{util, ...}: {
  plugins.which-key = {
    enable = true;

    # Document existing key chains
    settings.spec = [
      (util.whichkeyGroup "<leader>c" "[C]ode")
      (util.whichkeyGroup "<leader>d" "[D]ocument")
      (util.whichkeyGroup "<leader>r" "[R]ename")
      (util.whichkeyGroup "<leader>s" "[S]earcch")
      (util.whichkeyGroup "<leader>w" "[W]orkspace")
      (util.whichkeyGroup "<leader>t" "[T]oggle")
      # (util.whichkeyGroup "<leader>h" "Git [H]unk")
      {
        __unkeyed-1 = "<leader>h";
        group = "Git [H]unk";
        mode = ["n" "v"];
      }
    ];
  };
}

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        timeFormat = "2006-01-02";
        shortTimeFormat = "13:52";
      };
      git.paging.externalDiffCommand = "difft --color=always --display=inline";
    };
  };
}

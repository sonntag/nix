{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          timeFormat = "2006-01-02";
          shortTimeFormat = "13:52";
        };
        git.diffRenderers = [
          {
            command = "${pkgs.difftastic}/bin/difft";
            type = "extDiff";
          }
        ];
      };
    };
  };
}

{
  den.aspects.justin.homeManager = {lib, ...}: {
    programs.zellij = {
      enable = true;
      # enableFishIntegration = true;
      # attachExistingSession = true;
      # exitShellOnExit = true;
      themes.rose-pine = ./rose-pine.kdl;
      settings = {
        theme = "rose-pine";

        # pane_frames = false;
        # default_mode = "locked";
      };
    };
  };
}

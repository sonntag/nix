{
  den.aspects.justin.homeManager = {lib, ...}: {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;
      themes.rose-pine = ./rose-pine.kdl;
      settings = {
        theme = "rose-pine";
      };
    };
  };
}

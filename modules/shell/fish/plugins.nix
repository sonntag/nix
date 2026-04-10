{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    programs.fish.plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      {
        name = "bass";
        src = bass.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
      # {
      #   name = "sponge";
      #   src = pkgs.fishPlugins.sponge.src;
      # }
    ];
  };
}

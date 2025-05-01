{pkgs, ...}: {
  programs.fish = {
    plugins = [
      # {
      #   name = "sponge";
      #   src = pkgs.fishPlugins.sponge.src;
      # }
    ];
  };
}

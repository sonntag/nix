{pkgs, ...}: {
  programs.fish = {
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
    ];

    interactiveShellInit = ''
      set -g sponge_allow_previously_successful false
    '';
  };
}

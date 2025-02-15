{config, ...}: let
  d = config.xdg.dataHost;
  c = config.xdg.configHost;
  cache = config.xdg.cacheHost;
in {
  imports = [
    ./common.nix
    ./nushell
    ./starship
    ./terminals.nix
    ./tmux.nix
  ];

  home.sessionVariables = {
    # set default applications
    EDITOR = "nvim";
  };

  home.shellAliases = {
    k = "kubectl";
  };
}

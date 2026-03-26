{lib, ...}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    # TOML file downloaded from https://github.com/rose-pine/starship/tree/main
    settings = lib.importTOML ./rose-pine.toml;
  };
}

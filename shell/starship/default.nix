{lib, ...}: {
  # Starship Prompt
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.starship.enable
  programs.starship.enable = true;
  # TOML file downloaded from https://github.com/rose-pine/starship/tree/main
  programs.starship.settings = lib.importTOML ./rose-pine.toml;
}

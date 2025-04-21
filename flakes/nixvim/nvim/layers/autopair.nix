{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.autopair;
in {
  options.sonntag.layers.autopair.enable = mkEnableOption "autopair" // {default = true;};
  config.plugins.nvim-autopairs = mkIf cfg.enable {
    enable = true;
    settings = {
      map_bs = false;
    };
  };
}

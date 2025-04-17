{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.autopair;
in {
  options.sonntag.layers.autopair.enable = mkEnableOption "autopair" // {default = true;};
  config.plugins.nvim-autopairs.enable = cfg.enable;
}

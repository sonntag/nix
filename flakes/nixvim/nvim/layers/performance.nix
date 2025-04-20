{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.performance;
in {
  options.sonntag.layers.performance.enable = mkEnableOption "performance" // {default = true;};
  config = mkIf cfg.enable {
    # luaLoader.enable = true;
    # performance.byteCompileLua = {
    #   enable = true;
    #   configs = true;
    #   initLua = true;
    #   nvimRuntime = true;
    #   plugins = true;
    # };
  };
}

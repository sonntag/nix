{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.services.ollama;
in {
  options.sonntag.services.ollama.enable = mkEnableOption "ollama";
  config.services.ollama = {
    inherit (cfg) enable;
  };
}

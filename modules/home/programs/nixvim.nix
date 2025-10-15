{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.programs;
in {
  options.sonntag.programs.nixvim.enable = mkEnableOption "nixvim";
  config = mkIf cfg.nixvim.enable {
    programs.fish.shellAliases = {
      nixvim = "${inputs.nixvim.packages.aarch64-darwin.default}/bin/nvim";
    };
  };
}

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
    home.packages = mkIf (!cfg.nvim.enable) [
      inputs.nixvim.packages.aarch64-darwin.default
    ];

    programs.fish.shellAliases = mkIf cfg.nvim.enable {
      nixvim = "${inputs.nixvim.packages.aarch64-darwin.default}/bin/nvim";
    };
  };
}

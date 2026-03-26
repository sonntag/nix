{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.programs.nvim;
in {
  options.sonntag.programs.nvim.enable = mkEnableOption "nvim";
  config = mkIf cfg.enable {
    home.packages = [
      # TODO: this should depend on ${system}
      inputs.nvim.packages.aarch64-darwin.default
    ];
    home.sessionVariables.EDITOR = "nvim";
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkEnableOption mkIf;
  cfg = config.sonntag.nvim.languages.clojure;
in {
  options.sonntag.nvim.languages.clojure.enable = mkEnableOption "clojure";
  config.plugins = mkIf cfg.enable {
    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.clojure
    ];

    # conform-nvim.settings = {
    #   formatters = {
    #     cljstyle.command = getExe pkgs.cljstyle;
    #   };
    #
    #   formatters_by_ft = {
    #     clojure = ["cljstyle"];
    #   };
    # };
  };
}

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
  config = mkIf cfg.enable {
    sonntag.nvim.languages.lisp.enable = true;

    plugins = {
      conjure.enable = true;

      treesitter.grammarPackages = [
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.clojure
      ];

      conform-nvim.settings = {
        formatters.cljstyle.command = getExe pkgs.cljstyle;
        formatters_by_ft.clojure = ["cljstyle"];
      };

      lsp.servers.clojure_lsp = {
        enable = true;
        settings.rootMarkers = [".git"];
      };
    };
  };
}

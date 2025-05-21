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
      treesitter.grammarPackages = [
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.clojure
      ];

      conform-nvim.settings = {
        formatters = {
          # cljstyle.command = getExe pkgs.cljstyle;
          cljstyle.cwd.__raw = ''
            require("conform.util").root_file({ ".cljstyle" })
          '';
        };

        # TODO: use cljstyle from nix store instead of from my current environment
        formatters_by_ft = {
          clojure = ["cljstyle"];
        };
      };

      lsp.servers.clojure_lsp = {
        enable = true;
        # rootDir = "require('lspconfig.util').root_pattern('.git')";
      };
    };
  };
}

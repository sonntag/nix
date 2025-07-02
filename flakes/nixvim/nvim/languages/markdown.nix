{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins = {
    render-markdown.enable = true;

    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.markdown
    ];

    # conform-nvim.settings = {
    #   formatters = {
    #     mdformat.command = getExe pkgs.mdformat;
    #   };
    #
    #   formatters_by_ft = {
    #     markdown = ["mdformat"];
    #   };
    # };

    lsp.servers.marksman.enable = true;
  };
}

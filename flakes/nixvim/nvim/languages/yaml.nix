{pkgs, ...}: {
  plugins = {
    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.yaml
    ];

    lsp.servers.yamlls.enable = true;
  };
}

{pkgs, ...}: {
  plugins = {
    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.json
    ];

    lsp.servers.jsonls.enable = true;
  };
}

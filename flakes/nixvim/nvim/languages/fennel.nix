{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.nfnl
  ];

  extraConfigLua = ''
    require("nfnl").setup({})
  '';

  plugins = {
    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.fennel
    ];

    lsp.servers.fennel_ls.enable = true;
  };
}

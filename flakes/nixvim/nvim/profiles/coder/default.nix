{
  imports = [
    ./plugins/blink-cmp.nix
    ./plugins/lsp.nix
    ./plugins/luasnip.nix
    ./plugins/telescope.nix
    ./plugins/todo-comment.nix
    ./plugins/treesitter.nix
  ];

  sonntag.nvim.languages.clojure.enable = true;

  plugins.sleuth.enable = true;
}

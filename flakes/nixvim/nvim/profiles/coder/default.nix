{
  imports = [
    ./plugins/autopair.nix
    ./plugins/blink-cmp.nix
    ./plugins/lsp.nix
    ./plugins/luasnip.nix
    ./plugins/telescope.nix
    ./plugins/todo-comment.nix
    ./plugins/treesitter.nix
    # ./keymaps.nix
    # Adding this for testing purposes
    ../../languages/nix.nix
  ];
  plugins.sleuth.enable = true;
}

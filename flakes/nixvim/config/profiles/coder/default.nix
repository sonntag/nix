{
  imports = [
    ../base
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    # ./keymaps.nix
    # Adding this for testing purposes
    ../../languages/nix
  ];
  plugins.sleuth.enable = true;
}

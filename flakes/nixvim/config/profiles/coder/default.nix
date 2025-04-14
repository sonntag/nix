{
  imports = [
    ../base
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    # ./keymaps.nix
  ];
  plugins.sleuth.enable = true;
}

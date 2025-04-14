{pkgs, ...}: {
  plugins.treesitter.grammarPackages = [
    pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix
  ];
}

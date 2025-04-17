{
  lib,
  pkgs,
  self,
  system,
  ...
}: let
  inherit (lib) getExe;
in {
  plugins = {
    treesitter.grammarPackages = [
      pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix
    ];

    conform-nvim.settings = {
      formatters = {
        alejandra.command = getExe pkgs.alejandra;
      };

      formatters_by_ft = {
        nix = ["alejandra"];
      };
    };

    # https://nix-community.github.io/nixvim/plugins/lsp/index.html
    lsp.servers.nixd = {
      enable = true;
      settings = let
        flake = ''(builtins.getFlake "${self}")'';
      in {
        formatting.command = ["${getExe pkgs.alejandra}"];
        nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
        options.nixvim.expr = "${flake}.packages.${system}.nvim.options";
      };
    };
  };
}

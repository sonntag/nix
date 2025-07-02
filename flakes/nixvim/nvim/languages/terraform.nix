{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.sonntag.nvim.languages.terraform;
in {
  options.sonntag.nvim.languages.terraform.enable = mkEnableOption "terraform";
  config = mkIf cfg.enable {
    plugins = {
      treesitter.grammarPackages = [
        pkgs.vimPlugins.nvim-treesitter.builtGrammars.terraform
      ];

      conform-nvim.settings = {
        formatters_by_ft = {
          terraform = ["terraform_fmt"];
        };
      };

      lsp.servers.terraformls.enable = true;
    };
  };
}

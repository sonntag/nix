{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.lsp;
in {
  options.sonntag.layers.lsp.enable = mkEnableOption "lsp" // {default = true;};
  config.plugins.lsp = mkIf cfg.enable {
    enable = true;
    inlayHints = true;
    keymaps = {
      diagnostic = {
        "<leader>q" = {
          mode = "n";
          action = "setloclist";
          desc = "Open diagnostic [Q]uickfix list";
        };
      };
    };
  };
}

{
  config,
  lib,
  util,
  ...
}:
with lib; let
  inherit (util) keymap;
  cfg = config.sonntag.layers.trouble;
in {
  options.sonntag.layers.trouble.enable = mkEnableOption "trouble" // {default = true;};
  config = mkIf cfg.enable {
    plugins.trouble.enable = true;

    keymaps = [
      (keymap "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (Trouble)")
      (keymap "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics (Trouble)")
      (keymap "<leader>cs" "<cmd>Trouble symbols toggle<cr>" "Symbols (Trouble)")
      (keymap "<leader>cS" "<cmd>Trouble lsp toggle<cr>" "LSP references/definitions/... (Trouble)")
      (keymap "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List (Trouble)")
      (keymap "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List (Trouble)")
    ];
  };
}

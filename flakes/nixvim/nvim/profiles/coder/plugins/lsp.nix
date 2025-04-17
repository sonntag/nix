{
  plugins.lsp = {
    enable = true;
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

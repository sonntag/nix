{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.snippets;
in {
  options.sonntag.layers.snippets.enable = mkEnableOption "snippets" // {default = true;};
  config.plugins.luasnip = mkIf cfg.enable {
    enable = true;
    # lazyLoad.settings.lazy = true;

    # fromLua = [
    #   {
    #     paths = builtins.path {
    #       name = "neovim-snippets";
    #       path = ./snippets;
    #     };
    #   }
    # ];

    settings = {
      delete_check_events = "TextChanged";
      history = true;
    };
  };
}

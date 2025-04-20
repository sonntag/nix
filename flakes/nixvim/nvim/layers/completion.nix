{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.completion;
in {
  options.sonntag.layers.completion.enable = mkEnableOption "completion" // {default = true;};
  # https://nix-community.github.io/nixvim/plugins/blink-cmp/index.html

  # TODO: figure out how to get tab completion to work
  # TODO: add toggles for autosave

  config.plugins = mkIf cfg.enable {
    blink-cmp = {
      enable = true;

      # lazyLoad.settings = {
      #   before.__raw = ''
      #     function()
      #       require("lz.n").trigger_load("blink-compat")
      #       ${optionalString config.plugins.luasnip.enable ''require("lz.n").trigger_load("luasnip")''}
      #     end
      #   '';
      #   event = "DeferredUIEnter";
      # };

      settings = {
        appearance = {
          nerd_font_variant = "mono";
          use_nvim_cmp_as_default = false;
        };

        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
            };
          };

          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window.border = "rounded";
          };

          ghost_text = {
            enabled = true;
          };

          menu.border = "rounded";
        };

        fuzzy.prebuilt_binaries.download = false;

        signature = {
          enabled = true;
          window.border = "rounded";
        };

        snippets.preset = mkIf config.plugins.luasnip.enable "luasnip";

        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };
    };

    blink-compat = {
      enable = true;
      # lazyLoad.settings.lazy = true;
    };

    lsp.capabilities = ''
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    '';
  };
}

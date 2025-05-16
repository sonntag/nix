{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe';
in {
  plugins.conform-nvim = {
    enable = true;
    lazyLoad.settings = {
      cmd = "ConformInfo";
      event = "BufWritePre";
      keys = [
        {
          __unkeyed-1 = "<leader>cf";
          __unkeyed-2.__raw = ''
            function()
              require("conform").format({ async = true, lsp_format = "fallback" })
            end
          '';
          mode = ["n" "v"];
          desc = "Format buffer";
        }
      ];
    };

    settings = {
      format_on_save.__raw = ''
        function(bufnr)
          if not (vim.g.autoformat or vim.b[bufnr].autoformat) then
            return
          end

          return { timeout_ms = 500, lsp_format = "fallback", undojoin = true }
        end
      '';

      formatters = {
        squeeze_blanks.command = getExe' pkgs.coreutils "cat";
      };

      formatters_by_ft._ = [
        "squeeze_blanks"
        "trim_whitespace"
      ];

      notify_on_error = false;
    };
  };

  userCommands = {
    FormatDisable = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.autoformat = false
            vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
          else
            vim.g.autoformat = false
            vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
          end
        end
      '';
      desc = "Disable automatic formatting on save";
    };

    FormatEnable = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.autoformat = true
            vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
          else
            vim.g.autoformat = true
            vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
          end
        end
      '';
      desc = "Enable automatic formatting on save";
    };

    FormatToggle = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.autoformat = not vim.b.autoformat

            if vim.b.autoformat then
              vim.notify("Automatic formatting on save is now enabled for this buffer.", vim.log.levels.INFO)
            else
              vim.notify("Automatic formatting on save is now disabled for this buffer.", vim.log.levels.INFO)
            end
          else
            vim.g.autoformat = not vim.g.autoformat

            if vim.g.autoformat then
              vim.notify("Automatic formatting on save is now enabled.", vim.log.levels.INFO)
            else
              vim.notify("Automatic formatting on save is now disabled.", vim.log.levels.INFO)
            end
          end
        end
      '';
      desc = "Toggle automatic formatting on save";
    };
  };
}

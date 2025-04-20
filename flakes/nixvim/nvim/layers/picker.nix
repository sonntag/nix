{
  config,
  lib,
  util,
  ...
}:
with lib; let
  inherit (util) keymapLua;
  cfg = config.sonntag.layers.picker;
in {
  options.sonntag.layers.picker.enable = mkEnableOption "picker" // {default = true;};

  # TODO: get certain pickers to open in normal mode
  # TODO: change picker layouts
  # TODO: change notifier
  # TODO: figure out snippets?
  # TODO: how to have semicolon automatically added in nix
  config = mkIf cfg.enable {
    keymaps = [
      # Top Pickers & Explorer
      (keymapLua "<leader><space>" "Snacks.picker.smart()" "Smart Find Files")
      (keymapLua "<leader>," "Snacks.picker.buffers()" "Buffers")
      (keymapLua "<leader>/" "Snacks.picker.grep()" "Grep")
      (keymapLua "<leader>:" "Snacks.picker.command_history()" "Command History")
      (keymapLua "<leader>n" "Snacks.picker.notifications()" "Notification History")
      (keymapLua "<leader>e" "Snacks.explorer()" "File Explorer")

      # Find
      (keymapLua "<leader>ff" "Snacks.picker.files()" "Find Files")
      (keymapLua "<leader>fg" "Snacks.picker.git_files()" "Find Git Files")
      (keymapLua "<leader>fp" "Snacks.picker.projects()" "Projects")
      (keymapLua "<leader>fr" "Snacks.picker.recent()" "Recent")

      # Git
      (keymapLua "<leader>gb" "Snacks.picker.git_branches()" "Git Branches")
      (keymapLua "<leader>gl" "Snacks.picker.git_log()" "Git Log")
      (keymapLua "<leader>gL" "Snacks.picker.git_log_line()" "Git Log Line")
      (keymapLua "<leader>gs" "Snacks.picker.git_status()" "Git Status")
      (keymapLua "<leader>gS" "Snacks.picker.git_stash()" "Git Stash")
      (keymapLua "<leader>gd" "Snacks.picker.git_diff()" "Git Diff (Hunks)")
      (keymapLua "<leader>gf" "Snacks.picker.git_log_file()" "Git Log File")

      # Grep
      (keymapLua "<leader>sb" "Snacks.picker.lines()" "Buffer Lines")
      (keymapLua "<leader>sB" "Snacks.picker.grep_buffers()" "Grep Open Buffers")
      (keymapLua "<leader>sw" "Snacks.picker.grep_word()" "Visual selection or word" // {mode = ["n" "x"];})

      # Search
      (keymapLua "<leader>s\"" "Snacks.picker.registers()" "Registers")
      (keymapLua "<leader>s/" "Snacks.picker.search_history()" "Search History")
      (keymapLua "<leader>sa" "Snacks.picker.autocmds()" "Autocmds")
      (keymapLua "<leader>sc" "Snacks.picker.commands()" "Commands")
      (keymapLua "<leader>sd" "Snacks.picker.diagnostics()" "Diagnostics")
      (keymapLua "<leader>sD" "Snacks.picker.diagnostics_buffer()" "Buffer Diagnostics")
      (keymapLua "<leader>sh" "Snacks.picker.help()" "Help Pages")
      (keymapLua "<leader>sH" "Snacks.picker.highlights()" "Highlights")
      (keymapLua "<leader>si" "Snacks.picker.icons()" "Icons")
      (keymapLua "<leader>sj" "Snacks.picker.jumps()" "Jumps")
      (keymapLua "<leader>sk" "Snacks.picker.keymaps()" "Keymaps")
      (keymapLua "<leader>sl" "Snacks.picker.loclist()" "Location List")
      (keymapLua "<leader>sm" "Snacks.picker.marks()" "Marks")
      (keymapLua "<leader>sM" "Snacks.picker.man()" "Man Pages")
      # (keymapLua "<leader>sp" "Snacks.picker.lazy()" "Plugin Spec")
      (keymapLua "<leader>sq" "Snacks.picker.qflist()" "Quickfix List")
      (keymapLua "<leader>sr" "Snacks.picker.resume()" "Resume")
      (keymapLua "<leader>su" "Snacks.picker.undo()" "Undo History")

      # LSP
      (keymapLua "gd" "Snacks.picker.lsp_definitions()" "Goto Definition")
      (keymapLua "gD" "Snacks.picker.lsp_declarations()" "Goto Declaration")
      (keymapLua "gr" "Snacks.picker.lsp_references()" "References")
      (keymapLua "gI" "Snacks.picker.lsp_implementations()" "Goto Implementation")
      (keymapLua "gy" "Snacks.picker.lsp_type_definitions()" "Goto T[y]pe Definition")
      (keymapLua "<leader>ss" "Snacks.picker.lsp_symbols()" "LSP Symbols")
      (keymapLua "<leader>sS" "Snacks.picker.lsp_workspace_symbols()" "LSP Workspace Symbols")

      # Scratch
      (keymapLua "<leader>." "Snacks.scratch()" "Toggle Scratch Buffer")
      (keymapLua "<leader>S" "Snacks.scratch.select()" "Select Scratch Buffer")
    ];

    # plugins.telescope = {
    #   enable = true;
    #
    #   extensions = {
    #     # https://github.com/nvim-telescope/telescope-fzf-native.nvim
    #     fzf-native.enable = true;
    #     # https://github.com/nvim-telescope/telescope-ui-select.nvim
    #     ui-select.enable = true;
    #     # https://github.com/debugloop/telescope-undo.nvim
    #     undo.enable = true;
    #   };
    #
    #   keymaps = {
    #     "<leader>sh" = {
    #       mode = "n";
    #       action = "help_tags";
    #       options.desc = "[S]earch [H]elp";
    #     };
    #
    #     "<leader>sk" = {
    #       mode = "n";
    #       action = "keymaps";
    #       options.desc = "[S]earch [K]eymaps";
    #     };
    #
    #     "<leader>sf" = {
    #       mode = "n";
    #       action = "find_files";
    #       options.desc = "[S]earch [F]iles";
    #     };
    #
    #     "<leader>ss" = {
    #       mode = "n";
    #       action = "builtin";
    #       options.desc = "[S]earch [S]elect Telescope";
    #     };
    #
    #     "<leader>sw" = {
    #       mode = "n";
    #       action = "grep_string";
    #       options.desc = "[S]earch current [W]ord";
    #     };
    #
    #     "<leader>sg" = {
    #       mode = "n";
    #       action = "live_grep";
    #       options.desc = "[S]earch by [G]rep";
    #     };
    #
    #     "<leader>sd" = {
    #       mode = "n";
    #       action = "diagnostics";
    #       options.desc = "[S]earch [D]iagnostics";
    #     };
    #
    #     "<leader>sr" = {
    #       mode = "n";
    #       action = "resume";
    #       options.desc = "[S]earch [R]esume";
    #     };
    #
    #     "<leader>S" = {
    #       mode = "n";
    #       action = "oldfiles";
    #       options.desc = "[S]earch Recent Files ('.' for repeat)";
    #     };
    #
    #     "<leader><leader>" = {
    #       mode = "n";
    #       action = "buffers";
    #       options.desc = "[ ] Find existing buffers";
    #     };
    #   };
    #
    #   settings = {
    #     extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
    #   };
    # };
    #
    # keymaps = [
    #   {
    #     mode = "n";
    #     key = "<leader>/";
    #     # You can pass additional configuration to Telescope to change the theme, layout, etc.
    #     action.__raw = ''
    #       function()
    #         require('telescope.builtin').current_buffer_fuzzy_find(
    #           require('telescope.themes').get_dropdown {
    #             winblend = 10,
    #             previewer = false
    #           }
    #         )
    #       end
    #     '';
    #     options = {
    #       desc = "[/] Fuzzily search in current buffer";
    #     };
    #   }
    #   {
    #     mode = "n";
    #     key = "<leader>s/";
    #     # It's also possible to pass additional configuration options.
    #     #  See `:help telescope.builtin.live_grep()` for information about particular keys
    #     action.__raw = ''
    #       function()
    #         require('telescope.builtin').live_grep {
    #           grep_open_files = true,
    #           prompt_title = 'Live Grep in Open Files'
    #         }
    #       end
    #     '';
    #     options = {
    #       desc = "[S]earch [/] in Open Files";
    #     };
    #   }
    # ];
  };
}

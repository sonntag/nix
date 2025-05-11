{
  plugins.mini = {
    enable = true;
    modules.keymap = {};
    luaConfig.post = ''
      local map_multistep = require('mini.keymap').map_multistep

      local multiline_hungry_bs_condition = function()
        local line, lnum, col = vim.api.nvim_get_current_line(), vim.fn.line("."), vim.fn.col('.')
        local offset = vim.fn.mode() == 'i' and 1 or 0
        return lnum > 1 and line:sub(1, col - offset):find('^%s+$') ~= nil
      end

      local multiline_hungry_bs_action = function()
        return function()
          local lnum, col = vim.fn.line('.'), vim.fn.col('.')
          local lines = vim.api.nvim_buf_get_lines(0, lnum - 2, lnum, false)
          local prev_len, line = lines[1]:len(), lines[2]
          local offset = vim.fn.mode() == 'i' and 1 or 0

          vim.api.nvim_buf_set_text(0, lnum - 2, prev_len, lnum - 1, col - offset, {})
          vim.api.nvim_win_set_cursor(0, { lnum - 1, prev_len })

          -- If prev_line was empty then we need to make sure the line is properly indented
          if prev_len == 0 then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-F>", true, false, true), 'n', true)
          end
        end
      end

      local bs_steps = {
        {condition = multiline_hungry_bs_condition, action = multiline_hungry_bs_action},
        "hungry_bs",
        "nvimautopairs_bs"
      }

      map_multistep("i", "<bs>", bs_steps)
      map_multistep("i", "<tab>", {"blink_next", "luasnip_next"})
    '';
  };
}

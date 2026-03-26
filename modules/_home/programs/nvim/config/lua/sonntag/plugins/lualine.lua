local function maximize_status() return vim.t.maximized and '   ' or '' end

return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local lualine = require('lualine')
		lualine.setup {
			options = {
				theme = 'rose-pine',
			},
			-- sections = {
			-- 	lualine_a = {},
			-- 	lualine_b = { { "mode", { upper = true } } },
			-- 	lualine_c = { { "FugitiveHead" }, { maximize_status } },
			-- 	lualine_x = {
			-- 		{ "filetype" },
			-- 		{
			-- 			require("noice").api.status.mode.get,
			-- 			cond = require("noice").api.status.mode.has,
			-- 			color = { fg = "#ff9e64" },
			-- 		},
			-- 		{
			-- 			require("noice").api.status.search.get,
			-- 			cond = require("noice").api.status.search.has,
			-- 			color = { fg = "#ff9e64" },
			-- 		},
			-- 	},
			-- },
		}
	end,
}

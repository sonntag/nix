return {
	'folke/which-key.nvim',
	event = 'VeryLazy',
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require('which-key')

		wk.setup {}

		-- Maintaining windown splits
		wk.register({
			s = {
				name = 'Window Splits',
				e = { '<C-w>=', 'Make splits equal size' },
				h = { '<c-w>s', 'Split window horizontally' },
				v = { '<C-w>v', 'Split window vertically' },
				x = { '<cmd>close<CR>', 'Close current split' },
			},
		}, { prefix = '<leader>' })
	end,
}

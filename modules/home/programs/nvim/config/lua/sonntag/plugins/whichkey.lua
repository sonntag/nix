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
		wk.add {
			{ '<leader>s', group = 'Window Splits' },
			{ '<leader>se', '<C-w>=', desc = 'Make splits equal size' },
			{ '<leader>sh', '<c-w>s', desc = 'Split window horizontally' },
			{ '<leader>sv', '<C-w>v', desc = 'Split window vertically' },
			{ '<leader>sx', '<cmd>close<CR>', desc = 'Close current split' },
		}
	end,
}

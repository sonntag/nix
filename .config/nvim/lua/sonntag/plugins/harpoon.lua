return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local harpoon = require('harpoon')

		harpoon:setup {
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		}

		vim.keymap.set(
			'n',
			'<M-h>',
			function() harpoon:list():select(1) end,
			{ desc = 'Open Jot file', noremap = true, silent = true }
		)

		require('which-key').add {
			{ '<leader>h', group = 'Harpoon' },
			{ '<leader>ha', function() harpoon:list():add() end, desc = 'append' },
			{ '<leader>he', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = 'quick menu' },
			{ '<leader>hh', function() harpoon:list():select(1) end, desc = 'select 1' },
			{ '<leader>ht', function() harpoon:list():select(2) end, desc = 'select 2' },
			{ '<leader>hn', function() harpoon:list():select(3) end, desc = 'select 3' },
			{ '<leader>hs', function() harpoon:list():select(4) end, desc = 'select 4' },
		}
	end,
}

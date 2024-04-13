return {
	'nvim-tree/nvim-tree.lua',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	enabled = false,
	config = function()
		local nvimtree = require('nvim-tree')

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup {
			renderer = {
				group_empty = true,
			},
			view = {
				width = 50,
				-- centralized_selection = true,
			},
			update_focused_file = {
				enabled = true,
			},
		}

		local keymap = vim.keymap

		keymap.set(
			'n',
			'<leader>ee',
			'<cmd>NvimTreeFindFileToggle<CR>',
			{ desc = 'Toggle file explorer on current file' }
		)
		keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' })
		keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' })
	end,
}

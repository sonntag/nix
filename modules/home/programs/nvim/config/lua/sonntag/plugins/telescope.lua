return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'debugloop/telescope-undo.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
		},
	},
	config = function()
		local telescope = require('telescope')
		local builtin = require('telescope.builtin')
		local wk = require('which-key')

		telescope.setup {
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown {},
				},
				undo = {},
			},
		}

		telescope.load_extension('ui-select')
		telescope.load_extension('fzf')
		telescope.load_extension('undo')

		wk.add {
			{ '<leader>f', group = 'Telescope Find' },
			{ '<leader>ff', builtin.find_files, desc = 'Find File' },
			{ '<leader>fg', builtin.live_grep, desc = 'Live Grep' },
			{ '<leader>fb', builtin.buffers, desc = 'Buffers' },
			{ '<leader>fh', builtin.help_tags, desc = 'Help Tags' },
			{ '<leader>fu', '<cmd>Telescope undo<cr>', desc = 'Undo' },
		}
	end,
}

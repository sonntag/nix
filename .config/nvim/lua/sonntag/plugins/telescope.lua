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

		wk.register({
			f = {
				name = 'Telescope Find',
				f = { builtin.find_files, 'Find File' },
				g = { builtin.live_grep, 'Live Grep' },
				b = { builtin.buffers, 'Buffers' },
				h = { builtin.help_tags, 'Help Tags' },
				u = { '<cmd>Telescope undo<cr>', 'Undo' },
			},
		}, { prefix = '<leader>' })
	end,
}

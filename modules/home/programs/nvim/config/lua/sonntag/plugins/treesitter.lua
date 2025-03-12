return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPre', 'BufNewFile' },
	build = ':TSUpdate',
	dependencies = {
		'windwp/nvim-ts-autotag',
		'nvim-treesitter/nvim-treesitter-textobjects',
		'nvim-treesitter/nvim-treesitter-context',
	},
	config = function()
		require('nvim-treesitter').setup {}
		require('nvim-treesitter.configs').setup {
			auto_install = true,
			autotag = { enable = true },
			ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query' },
			highlight = { enable = true },
			indent = { enable = true },
		}
	end,
}

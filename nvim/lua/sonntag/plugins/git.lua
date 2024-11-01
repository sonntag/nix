return {
	-- Git integration. Adds the `Git` command.
	'tpope/vim-fugitive',

	-- Github browser. Adds the GBrowse command which opens GitHub
	'tpope/vim-rhubarb',

	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim', -- required
			'sindrets/diffview.nvim', -- optional - Diff integration
			'nvim-telescope/telescope.nvim', -- optional
		},
		config = true,
	},

	{
		'kdheepak/lazygit.nvim',
		cmd = {
			'LazyGit',
			'LazyGitConfig',
			'LazyGitCurrentFile',
			'LazyGitFilter',
			'LazyGitFilterCurrentFile',
		},
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
		},
	},

	-- Shows git changes in the left gutter
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			require('gitsigns').setup()

			vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk under cursor' })
			vim.keymap.set(
				'n',
				'<leader>gt',
				':Gitsigns toggle_current_line_blame<CR>',
				{ desc = 'Toggle blame on current line' }
			)
			vim.keymap.set('n', '<leader>gg', vim.cmd.Git, { desc = 'Open fugitive window' })
		end,
	},

	-- worktrees integration
	{
		'ThePrimeagen/git-worktree.nvim',
		config = function()
			local telescope = require('telescope')

			require('git-worktree').setup()
			telescope.load_extension('git_worktree')

			vim.keymap.set(
				'n',
				'<leader>gw',
				function() telescope.extensions.git_worktree.git_worktrees() end,
				{ desc = 'List worktrees' }
			)

			vim.keymap.set(
				'n',
				'<leader>gc',
				function() telescope.extensions.git_worktree.create_git_worktree() end,
				{ desc = 'Create worktree' }
			)
		end,
	},
}

return {
	-- Git integration. Adds the `Git` command.
	"tpope/vim-fugitive",

	-- Github browser. Adds the GBrowse command which opens GitHub
	"tpope/vim-rhubarb",

	-- Shows git changes in the left gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup()

			vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
			vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
			vim.keymap.set("n", "<leader>gg", vim.cmd.Git)
		end,
	},
}

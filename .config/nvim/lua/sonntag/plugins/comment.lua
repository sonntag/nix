return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		toggler = {
			line = "<leader>cc",
			block = "<leader>cb",
		},
		opleader = {
			line = "<leader>cc",
			block = "<leader>cb",
		},
		extra = {
			above = "<leader>cO",
			below = "<leader>co",
			eol = "<leader>cA",
		},
	},
}

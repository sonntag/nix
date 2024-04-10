return {
	"letieu/jot.lua",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.keymap.set("n", "gj", function()
			require("jot").open()
		end, { desc = "Open Jot file", noremap = true, silent = true })
	end,
}

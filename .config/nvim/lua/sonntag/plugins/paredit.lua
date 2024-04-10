return {
	"julienvincent/nvim-paredit",
	ft = { "clojure" },
	config = function()
		require("nvim-paredit").setup({})
	end,
}

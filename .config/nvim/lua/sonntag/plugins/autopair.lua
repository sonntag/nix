-- return {
-- 	"windwp/nvim-autopairs",
-- 	event = { "InsertEnter" },
-- 	config = true,
-- }
return {
	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	branch = "v0.6", --recomended as each new version will have breaking changes
	opts = {
		cr = {
			conf = {
				cond = function(fn)
					return vim.bo.filetype ~= "clojure"
				end,
			},
		},
	},
}

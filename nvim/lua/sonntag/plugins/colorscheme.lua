-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		require("catppuccin").setup({})
-- 		vim.cmd.colorscheme("catppuccin")
-- 	end,
-- }
return {
	'rose-pine/neovim',
	name = 'rose-pine',
	config = function() vim.cmd.colorscheme('rose-pine') end,
}
-- return {
-- 	"folke/tokyonight.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		require("tokyonight").setup({
-- 			style = "night",
-- 			styles = {
-- 				comments = { italic = true },
-- 			},
-- 		})
--
-- 		vim.cmd.colorscheme("tokyonight")
-- 	end,
-- }
-- return {
-- 	"shaunsingh/nord.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("nord")
-- 	end,
-- }

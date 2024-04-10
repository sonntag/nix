return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		})

		require("which-key").register({
			h = {
				name = "Harpoon",
				h = {
					function()
						harpoon:list():select(1)
					end,
					"select 1",
				},
				t = {
					function()
						harpoon:list():select(2)
					end,
					"select 2",
				},
				n = {
					function()
						harpoon:list():select(3)
					end,
					"select 3",
				},
				s = {
					function()
						harpoon:list():select(4)
					end,
					"select 4",
				},

				e = {
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					"quick menu",
				},
				a = {
					function()
						harpoon:list():add()
					end,
					"append",
				},
			},
		}, { prefix = "<leader>" })
	end,
}

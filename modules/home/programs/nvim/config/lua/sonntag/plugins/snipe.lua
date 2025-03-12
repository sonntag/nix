return {
	'leath-dub/snipe.nvim',
	keys = {
		{ 'gb', function() require('snipe').open_buffer_menu() end, desc = 'Open Snipe buffer menu' },
	},
	opts = {
		hints = {
			-- Charaters to use for hints
			-- make sure they don't collide with the navigation keymaps
			-- If you remove `j` and `k` from below, you can navigate in the plugin
			-- dictionary = "sadflewcmpghio",
			dictionary = 'asfghl;wertyuiop',
		},
		navigate = {
			cancel_snipe = '<esc>',
			close_buffer = 'd',
		},
	},
}

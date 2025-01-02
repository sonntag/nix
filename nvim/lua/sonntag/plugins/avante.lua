return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	lazy = false,
	version = false, -- set this if you want to always pull the latest change
	opts = {
		provider = 'openai',
		openai = {
			endpoint = 'http://Bedroc-Proxy-6LZc7RGHPlTd-326431626.us-west-2.elb.amazonaws.com/api/v1',
			model = 'anthropic.claude-3-5-sonnet-20241022-v2:0',
			api_key_name = 'cmd:vault read -field=key az-stage/secret/service/openai/bedrock',
		},
		windows = {
			wrap = true,
			width = '40',
			input = {
				height = 16,
			},
		},
	},
	build = 'make',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'stevearc/dressing.nvim',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'hrsh7th/nvim-cmp', -- autocomplete for avante commands and mentions
		'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
		-- 'zbirenbaum/copilot.lua', -- for providers='copilot'
		{
			-- support for image pasting
			'HakonHarnes/img-clip.nvim',
			event = 'VeryLazy',
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}

return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',

		-- Adds LSP completion capabilities
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',

		'hrsh7th/cmp-cmdline',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-buffer',

		-- Adds a number of user-friendly snippets
		'rafamadriz/friendly-snippets',

		-- Adds icons to autocomplete popup
		'onsails/lspkind.nvim',
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require('lspkind')

		cmp.setup {
			snippet = {
				expand = function(args) luasnip.lsp_expand(args.body) end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				format = lspkind.cmp_format {
					mode = 'symbol_text', -- show only symbol annotations
					-- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					-- can also be a function to dynamically calculate max width such as
					maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
					ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					show_labelDetails = true, -- show labelDetails in menu. Disabled by default

					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					before = function(entry, vim_item) return vim_item end,
				},
			},
			mapping = cmp.mapping.preset.insert {
				['<C-d>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			}, {
				{ name = 'buffer' },
			}),
		}

		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' },
			},
		})

		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' },
			}, {
				{ name = 'cmdline' },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}

return {
	'williamboman/mason.nvim',
	dependencies = {
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
	},
	config = function()
		local mason = require('mason')
		local mason_lspconfig = require('mason-lspconfig')
		local mason_tool_installer = require('mason-tool-installer')

		mason.setup {
			ui = {
				icons = {
					package_installed = '✓',
					package_pending = '➜',
					package_uninstalled = '✗',
				},
			},
		}

		mason_lspconfig.setup {
			ensure_installed = {
				'clojure_lsp',
				'gopls',
				'lua_ls',
				'taplo', -- For toml formatting and stuff
			},
			automatic_installation = true,
		}

		mason_tool_installer.setup {
			ensure_installed = {
				'stylua',
			},
			automatic_installation = true,
		}
	end,
}

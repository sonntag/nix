-- [nfnl] Compiled from fnl/plugins/treesitter.fnl by https://github.com/Olical/nfnl, do not edit.
local ts = require("nvim-treesitter")
ts.setup({})
local cfgs = require("nvim-treesitter.configs")
cfgs.setup({autotag = {enable = true}, highlight = {enable = true}, indent = {enable = true}})
return {}

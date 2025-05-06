-- [nfnl] fnl/config.fnl
require("plugins.oil")
require("plugins.treesitter")
vim.cmd.colorscheme("rose-pine")
local nix_cats = require("nix-cats")
nix_cats["load-if"]("lang.fennel")
return nix_cats["load-if"]("lang.nix")

-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local oil = require("oil")
oil.setup({})
do
  do local _ = {vim.keymap.set("n", "-", "<cmd>Oil<cr>", {desc = "Open parent directory", remap = true})} end
end
return {}

-- [nfnl] fnl/plugins/conform.fnl
local conform = require("conform")
conform.setup({formatters_by_ft = {clojure = {"cljstyle"}, nix = {"alejandra"}}, format_on_save = {lsp_fallback = true, timeout_ms = 500, async = false}})
return {}

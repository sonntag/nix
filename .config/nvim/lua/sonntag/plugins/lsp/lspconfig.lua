return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function() 
        local lspconfig = require("lspconfig")
    end,
}

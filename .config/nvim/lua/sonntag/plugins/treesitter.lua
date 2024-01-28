return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            autotag = { enable = true },
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
            highlight = {
                enable = true,
            },
            indent = { enable = true },
        })
    end,
}

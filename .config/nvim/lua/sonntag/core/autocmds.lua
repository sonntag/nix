-- Unfold all code when entering a buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = {"*"},
    command = "normal zR",
})

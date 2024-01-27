-- Unfold all code when entering a buffer
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = {"*"},
    command = "normal zR",
})

-- Save all files when leaving a buffer
vim.api.nvim_create_autocmd({ "BufLeave" }, { pattern = "*", command = "wa", nested = true })

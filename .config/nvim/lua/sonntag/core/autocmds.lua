-- Unfold all code when entering a buffer
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = { '*' },
	command = 'normal zR',
})

-- Automatically set absolute line numbering when entering insert mode
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
	pattern = { '*' },
	command = 'set norelativenumber',
})

-- Automatically set relative line numbering when leaving insert mode
vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
	pattern = { '*' },
	command = 'set relativenumber',
})

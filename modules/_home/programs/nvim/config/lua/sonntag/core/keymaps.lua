vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Keeps the cursor where it is in the line when joining
vim.keymap.set('n', 'J', 'mzJ`z')

-- Move cursor to the middle of the screen when paging up or down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Move selection to middle of screen when selecting search results
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Use option + up/down keys to move lines
vim.keymap.set('n', '<M-down>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', '<M-up>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })

vim.keymap.set('n', '<M-o>', 'o<ESC>', { desc = 'Insert a new line down in normal mode' })
-- TODO: add a branch here to clear highlights conditionally if they exist, otherwise keep normal behavior
vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { desc = 'Clear search highlights', silent = true })
-- keymap.set('n', '<leader>j', 'J', { desc = 'Join lines' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })

-- Line movement improvements
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move a line or groups of lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line(s) down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line(s) up' })

-- Attempt to make backspace work like it does in vscode
vim.keymap.set('i', '<BS>', function()
	local line = vim.fn.getline('.')
	local col = vim.fn.col('.')
	if line:sub(1, col - 2):match('^%s*$') then
		return '<C-o>k<C-o>J'
	else
		return '<BS>'
	end
end, { expr = true })

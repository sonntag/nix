vim.g.mapleader = ' '
vim.g.maplocalleader = ','

local keymap = vim.keymap

keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Use option + up/down keys to move lines
keymap.set('n', '<M-down>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
keymap.set('n', '<M-up>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })

keymap.set('n', '<M-o>', 'o<ESC>', { desc = 'Insert a new line down in normal mode' })
-- TODO: add a branch here to clear highlights conditionally if they exist, otherwise keep normal behavior
keymap.set('n', '<CR>', ':noh<CR><CR>', { desc = 'Clear search highlights', silent = true })
-- keymap.set('n', '<leader>j', 'J', { desc = 'Join lines' })
keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Close buffer' })
keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save' })

-- Line movement improvements
-- keymap.set('n', 'J', '5j', { desc = 'Move 5 lines down' })
-- keymap.set('n', 'K', '5k', { desc = 'Move 5 lines up' })
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- I don't know what these do...
keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move line down' })
keymap.set('v', '<M-k>', ":m '>+1<CR>gv=gv", { desc = 'Move line up' })

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

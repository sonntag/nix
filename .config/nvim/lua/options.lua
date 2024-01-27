-- Turn on line numbers and make numbers relative
vim.opt.number = true
vim.opt.relativenumber = true

-- When splitting a new screen, either split
-- right or split below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Turn of line wrapping
vim.opt.wrap = false

-- Use spaces instead of tabs, and set tab width to 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Synchronizes the system clipboard
-- with Neovim's clipboard
vim.opt.clipboard = "unnamedplus"

-- Keeps the cursor centered when scrolling
vim.opt.scrolloff = 999

-- Allows hilighting in blocks for visual block mode (ctrl-v)
vim.opt.virtualedit = "block"

-- Shows incremental commands in a split view along with inlineh
vim.opt.inccommand = "split"

-- Ignores case for autocomplete in command mode
vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.g.mapleader = " "

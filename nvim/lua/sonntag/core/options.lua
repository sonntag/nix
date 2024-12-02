local opt = vim.opt

opt.autoindent = true
opt.backspace = 'indent,eol,start'
-- opt.backspace = "eol"  -- testing this out for now
opt.clipboard:append('unnamedplus') -- syncs system clipboard with Neovim's
opt.cursorline = true -- puts a line under the cursorline
opt.expandtab = true -- no tabs!
--opt.foldmethod = "expr"
--opt.foldexpr = "nvim_treesitter#foldexpr()"  -- trying out code folding but will probably remove
opt.ignorecase = true -- ignore case for autocomplete in command mode
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4 -- makes sure the cursor is buffered by 4 lines when scrolling
opt.shiftwidth = 4 -- set tab width to 4
opt.showmode = false -- don't show mode
opt.signcolumn = 'yes' -- don't know what sign column is but I'm always showing it
opt.smartcase = true -- ignore "ignorecase" if autocomplete input contains capitals
opt.smartindent = true -- trying this, says it works well for c-like programs so may not work for clojure
opt.splitbelow = true
opt.splitright = true -- splits screen down and to the right
opt.swapfile = false -- don't use swapfiles
opt.tabstop = 4
opt.termguicolors = true
opt.undodir = vim.env.HOME .. '/.undodir'
opt.undofile = true
opt.undolevels = 100
opt.virtualedit = 'block' -- highlight in blocks for visual block mode (ctrl-v)
opt.wrap = false

local function get_winbar_path()
	local full_path = vim.fn.expand('%:p')
	return full_path:gsub(vim.fn.expand('$HOME'), '~')
end

local function get_buffer_count()
	local buffers = vim.fn.execute('ls')
	local count = 0
	-- Match only lines that represent buffers, typically starting with a number followed by a space
	for line in string.gmatch(buffers, '[^\r\n]+') do
		if string.match(line, '^%s*%d+') then count = count + 1 end
	end
	return count
end

local function update_winbar()
	local home_replaced = get_winbar_path()
	local buffer_count = get_buffer_count()
	vim.opt.winbar = '%#WinBar1#%m '
		.. '%#WinBar2#('
		.. buffer_count
		.. ') '
		.. '%#WinBar1#'
		.. home_replaced
		.. '%*%=%#WinBar2#'
	-- I don't need the hostname as I have it in lualine
	-- .. vim.fn.systemlist("hostname")[1]
end
-- Autocmd to update the winbar on BufEnter and WinEnter events
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
-- 	callback = update_winbar,
-- })

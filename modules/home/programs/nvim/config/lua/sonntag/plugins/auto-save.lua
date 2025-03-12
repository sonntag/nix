return {
	'okuuva/auto-save.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	enabled = false,
	opts = {
		condition = function(buf)
			-- Skip oil buffers
			if vim.bo[buf].filetype == 'oil' then return false end

			-- Get the full path of the buffer
			local path = vim.api.nvim_buf_get_name(buf)
			if path == '' then return false end

			-- Check if file is tracked by git
			vim.fn.system(string.format('git ls-files --error-unmatch "%s" 2>/dev/null', path))
			return vim.v.shell_error == 0
		end,
	},
}

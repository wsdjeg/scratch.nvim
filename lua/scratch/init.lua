local M = {}

local scratch_dir = vim.fn.stdpath("cache") .. "/scratch.nvim/"

function M.create(opt)
	local filename = vim.fn.input({
		prompt = "file name:",
	})

	vim.cmd.edit(scratch_dir .. filename)
end

function M.setup(opt)
	opt = opt or {}

	scratch_dir = opt.directory or scratch_dir
end

return M

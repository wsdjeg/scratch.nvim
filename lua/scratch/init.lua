local M = {}

local scratch_dir = vim.fn.stdpath("cache") .. "/scratch.nvim/"

function M.create(opt)
	local filename = vim.fn.input({
		prompt = "file name:",
	})

	if #filename > 0 then
		vim.cmd.edit(scratch_dir .. "/" .. filename)
	end
end

function M.setup(opt)
	opt = opt or {}

	scratch_dir = opt.directory or scratch_dir

	if vim.fn.isdirectory(scratch_dir) == 0 then
		vim.fn.mkdir(scratch_dir, "p")
	end
end

return M

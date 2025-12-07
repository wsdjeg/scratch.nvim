local M = {}

local config = {
    scratch_dir = vim.fn.stdpath('cache') .. '/scratch.nvim/',
    buflisted = false,
}

function M.create(opt)
    local filename = vim.fn.input({
        prompt = 'file name:',
    })

    if #filename > 0 then
        vim.cmd.edit(config.scratch_dir .. '/' .. filename)
        vim.api.nvim_set_option_value('buflisted', config.buflisted, { buf = 0 })
    end
end

function M.setup(opt)
    opt = opt or {}

    config.scratch_dir = opt.directory or config.scratch_dir
    if type(opt.buflisted) == 'boolean' then
        config.buflisted = opt.buflisted
    end

    if vim.fn.isdirectory(config.scratch_dir) == 0 then
        vim.fn.mkdir(config.scratch_dir, 'p')
    end
end

function M.get_directory()
    return config.scratch_dir
end

function M.get_config()
    return config
end

return M

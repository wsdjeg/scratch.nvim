local M = {}

local config = {
    scratch_dir = vim.fn.stdpath('cache') .. '/scratch.nvim/',
    buflisted = false,
}

function M.create(opt)
    local buffer
    if opt.nofile then
        buffer = vim.api.nvim_create_buf(config.buflisted, false)
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buffer })
        if opt.filetype then
            vim.api.nvim_set_option_value('filetype', opt.filetype, { buf = buffer })
        end
    else
        local filename = vim.fn.input({
            prompt = 'file name:',
        })
        if #filename > 0 then
            buffer = vim.fn.bufload(config.scratch_dir .. '/' .. filename)
        end
    end

    if buffer then
        vim.api.nvim_set_option_value('buflisted', config.buflisted, { buf = buffer })
        vim.api.nvim_win_set_buf(0, buffer)
    end
    return ''
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

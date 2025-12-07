local M = {}

local previewer = require('picker.previewer.file')
local buf_previewer = require('picker.previewer.buffer')

local list_files_cmd = { 'rg', '--files' }

local devicon

local config = require('scratch').get_config()

local function get_path(f)
    return config.scratch_dir .. '/' .. f
end

function M.set(opt)
    opt = opt or {}

    if opt.cmd then
        list_files_cmd = opt.cmd
    end
    local ok
    ok, devicon = pcall(require, 'nvim-web-devicons')
    if not ok then
        devicon = nil
    end
end

function M.get()
    local items = vim.tbl_map(
        function(t)
            if devicon then
                local icon, hl = devicon.get_icon(t)
                return {
                    value = { file = get_path(t) },
                    str = (icon or '󰈔') .. ' ' .. t,
                    highlight = {
                        { 0, 2, hl },
                    },
                }
            end
            return {
                value = { file = get_path(t) },
                str = t,
            }
        end,
        vim.split(
            vim.system(list_files_cmd, { text = true, cwd = require('scratch').get_directory() })
                :wait().stdout,
            '\n',
            { trimempty = true }
        )
    )
    for _, buf in ipairs(require('scratch').get_nofile_buffers()) do
        local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
        if devicon then
            local icon, hl = devicon.get_icon_by_filetype(ft)
            table.insert(items, {
                value = { buf = buf },
                str = (icon or '󰈔') .. ' No Name',
                highlight = {
                    { 0, 2, hl },
                },
            })
        else
            table.insert(items, {
                value = { buf = buf },
                str = 'No Name' .. ' filetype:' .. ft,
            })
        end
    end
    return items
end

function M.actions()
    return {
        ['<C-v>'] = function(entry)
            if entry.value.buf then
                vim.cmd.split()
                vim.api.nvim_win_set_buf(0, entry.value.buf)
            else
                vim.cmd('vsplit ' .. entry.value.file)
                vim.api.nvim_set_option_value('buflisted', config.buflisted, { buf = 0 })
            end
        end,
        ['<C-t>'] = function(entry)
            if entry.value.buf then
                vim.cmd.tabnew()
                vim.api.nvim_win_set_buf(0, entry.value.buf)
            else
                vim.cmd('tabedit ' .. entry.value.file)
                vim.api.nvim_set_option_value('buflisted', config.buflisted, { buf = 0 })
            end
        end,
    }
end

local hidden = true

function M.redraw_actions()
    return {
        ['<C-h>'] = function(entry)
            if hidden then
                list_files_cmd = { 'rg', '--files', '--hidden' }
                hidden = false
            else
                list_files_cmd = { 'rg', '--files' }
                hidden = true
            end
        end,
    }
end

---@field item PickerItem
function M.default_action(item)
    if item.value.buf then
        vim.api.nvim_win_set_buf(0, item.value.buf)
    else
        vim.cmd('edit ' .. item.value.file)
        vim.api.nvim_set_option_value('buflisted', config.buflisted, { buf = 0 })
    end
end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
    if item.value.buf then
        buf_previewer.filetype = vim.api.nvim_get_option_value('filetype', { buf = item.value.buf })
        buf_previewer.buflines = vim.api.nvim_buf_get_lines(item.value.buf, 0, -1, false)
        vim.g.wsdjeg = buf_previewer.buflines
        buf_previewer.preview(1, win, buf, true)
    else
        previewer.preview(item.value.file, win, buf)
    end
end

return M

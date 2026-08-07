local lu = require('luaunit')

TestScratchExample = {}

local test_dir

function TestScratchExample:setUp()
    test_dir = vim.fn.tempname() .. '_scratch_test'
    vim.fn.mkdir(test_dir, 'p')

    require('scratch').setup({
        directory = test_dir .. '/',
        buflisted = false,
    })
end

function TestScratchExample:tearDown()
    if test_dir and vim.fn.isdirectory(test_dir) == 1 then
        vim.fn.delete(test_dir, 'rf')
    end
end

function TestScratchExample:test_setup_creates_directory()
    lu.assertEquals(vim.fn.isdirectory(test_dir), 1)
end

function TestScratchExample:test_get_directory()
    local dir = require('scratch').get_directory()
    lu.assertEquals(dir, test_dir .. '/')
end

function TestScratchExample:test_get_config()
    local config = require('scratch').get_config()
    lu.assertEquals(config.scratch_dir, test_dir .. '/')
    lu.assertEquals(config.buflisted, false)
end

function TestScratchExample:test_create_nofile_buffer()
    local scratch = require('scratch')
    scratch.create({ nofile = true, filetype = 'lua' })

    local buffers = scratch.get_nofile_buffers()
    lu.assertTrue(#buffers > 0)

    local buf = buffers[#buffers]
    lu.assertEquals(vim.api.nvim_get_option_value('buftype', { buf = buf }), 'nofile')
    lu.assertEquals(vim.api.nvim_get_option_value('filetype', { buf = buf }), 'lua')
end

function TestScratchExample:test_get_nofile_buffers_filters_invalid()
    local scratch = require('scratch')
    scratch.create({ nofile = true, filetype = 'python' })

    local buffers = scratch.get_nofile_buffers()
    lu.assertTrue(#buffers > 0)

    -- Delete the buffer and verify it's filtered out
    local buf = buffers[#buffers]
    vim.api.nvim_buf_delete(buf, { force = true })

    local filtered = scratch.get_nofile_buffers()
    for _, b in ipairs(filtered) do
        lu.assertNotEquals(b, buf)
    end
end

return TestScratchExample


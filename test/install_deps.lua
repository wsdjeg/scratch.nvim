-- test/install_deps.lua
-- Install test dependencies (luaunit) cross-platform
-- Usage: nvim -u NONE -l test/install_deps.lua

local deps_dir = 'test/.deps'

-- Ensure deps directory exists
vim.fn.mkdir(deps_dir, 'p')

-- Dependencies to install
-- Each entry: { name = ..., url = ..., target_path = ... }
local deps = {
    {
        name = 'luaunit',
        url = 'https://raw.githubusercontent.com/bluebird75/luaunit/master/luaunit.lua',
        target_path = deps_dir .. '/luaunit.lua',
    },
}

-- Download a file using available tools (curl/powershell/wget)
-- @param url string: URL to download
-- @param target_path string: Local file path to save
-- @return boolean: true on success, false on failure
local function download_file(url, target_path)
    -- Try curl first
    if vim.fn.executable('curl') == 1 then
        local cmd = { 'curl', '-fSL', '-o', target_path, url }
        local result = vim.system(cmd, { text = true }):wait()
        if result.code == 0 then
            return true
        end
        print('[WARN] curl failed: ' .. (result.stderr or 'unknown error'))
    end

    -- Try wget
    if vim.fn.executable('wget') == 1 then
        local cmd = { 'wget', '-q', '-O', target_path, url }
        local result = vim.system(cmd, { text = true }):wait()
        if result.code == 0 then
            return true
        end
        print('[WARN] wget failed: ' .. (result.stderr or 'unknown error'))
    end

    -- Try PowerShell (Windows fallback)
    if vim.fn.has('win32') == 1 then
        local ps_cmd = string.format(
            [[Invoke-WebRequest -Uri '%s' -OutFile '%s']],
            url,
            target_path
        )
        local result = vim.system({ 'powershell', '-NoProfile', '-Command', ps_cmd }, { text = true }):wait()
        if result.code == 0 then
            return true
        end
        print('[WARN] PowerShell failed: ' .. (result.stderr or 'unknown error'))
    end

    return false
end

-- Main installation logic
local function install()
    print('=== Installing test dependencies ===')
    print('Target directory: ' .. deps_dir)

    local all_ok = true

    for _, dep in ipairs(deps) do
        -- Check if already installed
        if vim.fn.filereadable(dep.target_path) == 1 then
            print(string.format('[SKIP] %s already installed at %s', dep.name, dep.target_path))
        else
            print(string.format('[INSTALL] Downloading %s from %s', dep.name, dep.url))
            local ok = download_file(dep.url, dep.target_path)
            if ok then
                print(string.format('[OK] %s installed successfully', dep.name))
            else
                print(string.format('[FAIL] Failed to install %s', dep.name))
                all_ok = false
            end
        end
    end

    if all_ok then
        print('\n=== All dependencies installed successfully ===')
        return 0
    else
        print('\n=== Some dependencies failed to install ===')
        return 1
    end
end

-- Run installation and exit
local exit_code = install()
os.exit(exit_code)


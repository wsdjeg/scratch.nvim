# scratch.nvm

scratch file manager for neovim

[![GitHub License](https://img.shields.io/github/license/wsdjeg/scratch.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/scratch.nvim)](https://luarocks.org/modules/wsdjeg/scratch.nvim)

## Installation

Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
    { 'wsdjeg/scratch.nvim' }
})
```

Then use `:Plug install scratch.nvim` to install this plugin.

## Setup

```lua
require('scratch').setup({
    directory = '~/.scratch'
})
```

## Basic usage

```lua
vim.keymap.set('n', '<leader>bs', function()
    require('scratch').create({})
end, { silent = true })
```

scratch.nvim also provides a picker.nvim source, which is used to fuzzy find scratch files.

```
:Picker scratch
```



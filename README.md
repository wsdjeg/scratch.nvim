# scratch.nvim

A lightweight scratch file manager for Neovim.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/scratch.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/scratch.nvim)](https://github.com/wsdjeg/scratch.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/scratch.nvim)](https://luarocks.org/modules/wsdjeg/scratch.nvim)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Setup](#setup)
- [Basic usage](#basic-usage)
- [Integration with picker.nvim](#integration-with-pickernvim)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

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
    directory = '~/.scratch',
    buflisted = false,
})
```

## Basic usage

Create new scratch file:

```lua
vim.keymap.set('n', '<leader>bs', function()
    require('scratch').create({})
end, { silent = true })
```

## Integration with picker.nvim

scratch.nvim provides a picker.nvim source to fuzzy find scratch files.

```
:Picker scratch
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.

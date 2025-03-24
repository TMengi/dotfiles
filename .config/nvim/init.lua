-- My conquest begins to reconfigure nvim in lua from scratch

-- TODO
-- [ ] better markdown support
--   - [x] treesitter highlighting
--   - [x] lsp
--   - [ ] previewer?
-- [ ] Check out configuration options for noice.lua

local g = vim.g

-- Leader is space
g.mapleader = ' '
g.maplocalleader = ' '

require('core.editor')
require('core.plugins')
require('plugin_config')

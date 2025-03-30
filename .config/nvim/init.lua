-- My conquest begins to reconfigure nvim in lua from scratch

-- TODO
-- [ ] Check out configuration options for noice.lua
-- [x] Break up editor for language specific stuff
--      probably includes learning how to import functions from other files
-- [ ] Configure snippet engine

local g = vim.g

-- Leader is space
g.mapleader = ' '
g.maplocalleader = ' '

require('core.editor')
require('core.plugins')
require('filetype_config')
require('plugin_config')

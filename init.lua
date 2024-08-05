-- My conquest begins to reconfigure nvim in lua from scratch

-- TODO
-- [ ] Code formatting
--   - [x] lua
--   - [x] python
--   - [ ] C++
--   - [x] rust
-- [ ] LSP for C++
-- [ ] faster telescope sorting (there are recommendations on the github page)

local g = vim.g

-- Leader is space
g.mapleader = ' '
g.maplocalleader = ' '

require('core.editor')
require('core.plugins')
require('plugin_config')

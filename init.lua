-- My conquest begins to reconfigure nvim in lua from scratch

local g = vim.g             -- Global variables
local opt = vim.opt         -- Options
local keymap = vim.keymap   -- Set keybindings

-- Leader is space
g.mapleader = ' '
g.maplocalleader = ' '

-- Tab/indent behavior
opt.expandtab = true    -- Use spaces instead of tabs
opt.shiftwidth = 4      -- Shift 4 spaces on tab
opt.tabstop = 4         -- 1 tab = 4 spaces

-- Search and highlighting
opt.smartcase = true
opt.hls = true
keymap.set('n', '<leader>hh', ':set hls!<cr>', {silent = true})

-- Split windows the way I expect them
opt.splitbelow = true
opt.splitright = true

-- Window navigation
keymap.set('n', '<c-h>', '<c-w>h', {silent = true})
keymap.set('n', '<c-j>', '<c-w>j', {silent = true})
keymap.set('n', '<c-k>', '<c-w>k', {silent = true})
keymap.set('n', '<c-l>', '<c-w>l', {silent = true})
keymap.set('n', '<leader>wq', ':windo wq<cr>', {silent = true})

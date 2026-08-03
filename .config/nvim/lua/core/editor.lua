-- Basic editor configuration. Covers things like tabs/indentation,
-- searching/highlighting, window navigation, etc.

local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local opt = vim.opt
local opt_local = vim.opt_local
local wo = vim.wo

local noremap = { noremap = true }
local silent_noremap = { silent = true, noremap = true }

-- ============================================================================
-- Basic editor behavior
-- ============================================================================

-- Tabs/indents
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Shift n spaces on tab
opt.tabstop = 2 -- 1 tab = n spaces
local four_spaces = function()
  opt_local.tabstop = 4
  opt_local.shiftwidth = 4
end
api.nvim_create_autocmd('FileType', {
  desc = 'Some languages indent with a different number of spaces',
  pattern = { 'python', 'rust', 'markdown', 'pants', 'matlab', 'bzl' },
  callback = four_spaces,
})
-- This might not actually be necessary since you're never editing a man page
api.nvim_create_autocmd('FileType', {
  desc = 'man pages have really weird spacing',
  pattern = { 'man' },
  callback = function()
    opt_local.tabstop = 7
    opt_local.shiftwidth = 7
  end,
})

-- Search and highlighting
opt.smartcase = true
opt.hls = true
keymap.set('n', '<leader>hh', ':set hls!<cr>', silent_noremap)

-- Split windows the way I expect them
opt.splitbelow = true
opt.splitright = true

-- Line numbering
opt.number = true

-- Line length and rulers
opt.textwidth = 79
opt.colorcolumn = '80,120'

-- Always show the signcolumn, otherwise it shifts the text each time
-- diagnostics appear or become resolved
opt.signcolumn = 'yes'

-- Underline cursor line in insert mode
api.nvim_create_autocmd({ 'InsertEnter' }, {
  callback = function()
    opt.cul = true
  end,
})
api.nvim_create_autocmd({ 'InsertLeave' }, {
  callback = function()
    opt.cul = false
  end,
})

-- Update faster than the default 4000 ms
opt.updatetime = 100

-- Shortcut to unconceal formatting characters
keymap.set('n', '<leader>cl', function()
  opt.conceallevel = 0
end, silent_noremap)

-- Set commenting format options. Should be able to do this once with
-- ops.formatoptions:remove({ 'tcro' }), but it seems like they get reset on
-- each file open event.
api.nvim_create_autocmd('FileType', {
  desc = 'Remote format options',
  command = 'set formatoptions=rqj',
})
-- Autoreload changed buffers
api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- ============================================================================
-- Special commands and keymaps
-- ============================================================================

-- Quick save
keymap.set('n', '<leader>ww', ':w<cr>', silent_noremap)

-- Window navigation and resizing
keymap.set('n', '<c-h>', '<c-w>h', silent_noremap)
keymap.set('n', '<c-j>', '<c-w>j', silent_noremap)
keymap.set('n', '<c-k>', '<c-w>k', silent_noremap)
keymap.set('n', '<c-l>', '<c-w>l', silent_noremap)
keymap.set('n', '<up>', ':resize +1<cr>', silent_noremap)
keymap.set('n', '<down>', ':resize -1<cr>', silent_noremap)
keymap.set('n', '<left>', ':vertical resize -1<cr>', silent_noremap)
keymap.set('n', '<right>', ':vertical resize +1<cr>', silent_noremap)
keymap.set('n', '<leader>wq', ':windo q<cr>', silent_noremap)
keymap.set('n', '<leader>=', '<c-w>=', silent_noremap)
keymap.set('n', '<leader>tn', ':tabnew<cr>', silent_noremap)

-- Additive highlighting
keymap.set('n', '<leader>*', 'viwy/<up>\\|\\<<c-r>0\\><cr>', silent_noremap)

-- Github view macro
keymap.set('n', '<leader>v', ':!gv %<cr>', silent_noremap)

-- Search for git merge conflicts
keymap.set('n', '<leader>cf', '/<<<<<<<\\|=======\\|>>>>>>><cr>', noremap)

-- Command to split newline delimited raw strings
api.nvim_create_user_command('Splitlines', [[%s/\\n/\r/g]], {})

-- Sort selected lines
keymap.set('v', '<leader>s', ':sort<cr>', silent_noremap)

-- Copy the current filepath to clipboard
keymap.set('n', '<leader>gc', function()
  local spath = vim.fn.expand('%')
  spath = string.gsub(spath, '\n', '')
  fn.setreg('+', { spath }, 'c')
  fn.setreg('"', { spath }, 'c')
  api.nvim_echo({ { spath, 'Normal' } }, false, {})
end, {
  desc = 'Copy current file path to clipboards',
})

-- Toggle wrap
keymap.set('n', '<leader>nw', function()
  wo.wrap = not wo.wrap
end, silent_noremap)

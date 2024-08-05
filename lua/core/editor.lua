-- Basic editor configuration. Covers things like tabs/indentation,
-- searching/highlighting, window navigation, etc.

local api = vim.api
local keymap = vim.keymap
local opt = vim.opt
local opt_local = vim.opt_local

-- Tab/indent behavior
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

-- Search and highlighting
opt.smartcase = true
opt.hls = true
keymap.set('n', '<leader>hh', ':set hls!<cr>', { silent = true })

-- Split windows the way I expect them
opt.splitbelow = true
opt.splitright = true

-- Window navigation and resizing
local silent_noremap = { silent = true, noremap = true }
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

-- Line numbering
opt.number = true

-- Line length and rulers
opt.textwidth = 79
opt.colorcolumn = '80,120'
api.nvim_create_autocmd('FileType', {
  desc = 'Rust allows longer line lengths',
  pattern = 'rust',
  callback = function()
    opt_local.textwidth = 99
    opt_local.colorcolumn = '100'
  end,
})

-- Make the cmd window taller for displaying errors
opt.cmdheight = 2

-- Always show the signcolumn, otherwise it shifts the text each time
-- diagnostics appear or become resolved
opt.signcolumn = 'yes'

-- Inderline cursor line in insert mode
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

-- Unconceal formatting characters
keymap.set('n', '<leader>cl', function()
  opt.conceallevel = 0
end, silent_noremap)

-- Set the filetype for some uncommon extensions
local buffer_events = { 'BufNewFile', 'BufEnter', 'BufRead' }
local filetype_like = function(pattern, desired_filetype)
  -- Sets the filetype for ``patern`` files to be ``desired_filetype``
  api.nvim_create_autocmd(buffer_events, {
    pattern = pattern,
    callback = function()
      opt_local.filetype = desired_filetype
    end,
  })
end
filetype_like('BUILD.pants', 'pants')
filetype_like('*.script', 'matlab') -- Pretend GMAT scripts are matlab
filetype_like('*.prototxt', 'prototxt')

-- Explicitly set syntax for certain uncommon filetypes
local highlight_like = function(pattern, desired_syntax)
  -- Highlights `pattern` files like they are `desired_syntax` files
  api.nvim_create_autocmd(buffer_events, {
    pattern = pattern,
    callback = function()
      opt_local.syntax = desired_syntax
    end,
  })
end
highlight_like('*.sim', 'yaml')
highlight_like('*.prototxt', 'yaml')
highlight_like('BUILD.pants', 'python')

-- Explicitly set the comment string for certain uncommon filetypes
local set_commentstring = function(filetype, commentstring)
  api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function()
      opt_local.commentstring = commentstring .. ' %s'
    end,
  })
end
set_commentstring('pants', '#')
set_commentstring('prototxt', '#')
set_commentstring('kdl', '//')

-- Additive highlighting
keymap.set('n', '<leader>*', 'viwy/<up>\\|\\<<c-r>0\\><cr>', silent_noremap)

-- Github view macro
keymap.set('n', '<leader>v', ':!gv %<cr>')

-- Don't autowrap text
opt.formatoptions:remove({ 't' })

-- Search for merge conflicts
keymap.set('n', '<leader>cf', '/<<<<<<<\\|=======\\|>>>>>>><cr>', { noremap = true })

-- Autoreload changed buffers
api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Quickfix list shortcuts
local noremap = { noremap = true }
keymap.set('n', '<leader>co', ':copen<cr>', noremap)
keymap.set('n', '<leader>cc', ':cclose<cr>', noremap)
keymap.set('n', ']q', ':cnext<cr>', noremap)
keymap.set('n', '[q', ':cprev<cr>', noremap)
keymap.set('n', '<leader>cq', ':call setqflist([])<cr>', noremap)

-- Functions and keymaps to open all quickfix items in various splits
local qfopen_wrapper = function(...)
  local qfopen = function(cmd)
    vim.cmd.cfdo('silent ' .. cmd .. ' %')
    vim.cmd.quit()
  end
  local args = { ... }
  return function()
    qfopen(unpack(args))
    vim.cmd.cclose()
  end
end
keymap.set('n', '<leader>os', qfopen_wrapper('sp'), noremap)
keymap.set('n', '<leader>ov', qfopen_wrapper('vs'), noremap)
keymap.set('n', '<leader>ot', qfopen_wrapper('tabnew'), noremap)

-- Command to split newline delimited raw strings
vim.api.nvim_create_user_command('Splitlines', [[%s/\\n/\r/g]], {})

local qftools = require('my_plugins.qftools')

local keymap = vim.keymap
local opts = { silent = true, noremap = true }

keymap.set('n', '<leader>co', ':copen<cr>', opts)
keymap.set('n', '<leader>cc', ':cclose<cr>', opts)
keymap.set('n', ']q', ':cnext<cr>', opts)
keymap.set('n', '[q', ':cprev<cr>', opts)
keymap.set('n', '<leader>cq', ':call setqflist([])<cr>', opts)
keymap.set('n', '<leader>os', qftools.qfopen_split, opts)
keymap.set('n', '<leader>ov', qftools.qfopen_vsplit, opts)
keymap.set('n', '<leader>ot', qftools.qfopen_tab, opts)

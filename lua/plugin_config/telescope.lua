local keymap = vim.keymap

local builtin = require('telescope.builtin')

local opts = { noremap = true }
keymap.set('n', '<leader>p', builtin.find_files, opts)
keymap.set('n', '<leader><leader>', builtin.oldfiles, opts)
keymap.set('n', '<leader>fg', builtin.live_grep, opts)
keymap.set('n', '<leader>fh', builtin.help_tags, opts)
keymap.set('n', '<leader>g', builtin.diagnostics, opts)
keymap.set('n', '<leader>cto', builtin.quickfix, opts)

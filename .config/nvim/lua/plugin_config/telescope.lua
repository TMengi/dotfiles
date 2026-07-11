local keymap = vim.keymap

local telescope = require('telescope')
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      'vxworks_system',
      'third_party',
    },
  },
})

local builtin = require('telescope.builtin')

local opts = { noremap = true }
keymap.set('n', '<leader>p', builtin.find_files, opts)
keymap.set('n', '<leader><leader>', builtin.oldfiles, opts)
keymap.set('n', '<leader>fg', builtin.live_grep, opts)
keymap.set('n', '<leader>fr', builtin.resume, opts)
keymap.set('n', '<leader>fh', builtin.help_tags, opts)
keymap.set('n', '<leader>gd', builtin.diagnostics, opts)
keymap.set('n', '<leader>cto', builtin.quickfix, opts)

-- Move the default history pickers into telescope
keymap.set('n', 'q/', builtin.search_history, opts)
keymap.set('n', 'q:', builtin.command_history, opts)

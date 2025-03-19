local keymap = vim.keymap

require('gitblame').setup({
  enabled = false,
})

keymap.set('n', '<leader>gbt', ':GitBlameToggle<cr>', { silent = true })
keymap.set('n', '<leader>gbo', ':GitBlameOpenFileURL<cr>', { silent = true })

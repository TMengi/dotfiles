local g = vim.g
local keymap = vim.keymap

-- Disable netrw, the builtin vim filetree viewer
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
  filters = {
    dotfiles = false, -- Show dotfiles
  },
  view = {
    width = 30,
  },
})

keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<cr>', { silent = true })

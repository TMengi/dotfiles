local keymap = vim.keymap
local g = vim.g

g.lazygit_floating_window_use_plenary = true

-- Keybinding to open lazygit
keymap.set('n', '<leader>gg', ':LazyGit<cr>', { silent = true, noremap = true })

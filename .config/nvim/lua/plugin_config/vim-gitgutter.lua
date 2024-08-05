local g = vim.g
local keymap = vim.keymap

-- Save the current colorscheme because gitgutter might break the signcolumn
-- colors
local colorscheme = vim.api.nvim_exec('colorscheme', true)

local opts = { noremap = true }
keymap.set('n', '<leader>db', function()
  g.gitgutter_diff_base = 'HEAD'
  vim.cmd('GitGutterAll')
end, opts)
keymap.set('n', '<leader>dh', function()
  g.gitgutter_diff_base = 'HEAD~'
  vim.cmd('GitGutterAll')
end, opts)
keymap.set('n', '<leader>dm', function()
  g.gitgutter_diff_base = 'master'
  vim.cmd('GitGutterAll')
end, opts)
keymap.set('n', '<leader>du', function()
  g.gitgutter_diff_base = '@{upstream}'
  vim.cmd('GitGutterAll')
end, opts)

-- Don't use the popup window for previews
g.gitgutter_preview_win_floating = false

-- Reapply the colorscheme to fix the signcolumn colors
vim.cmd('colorscheme ' .. colorscheme)

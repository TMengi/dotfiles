local leap = require('leap')
local clever = require('leap.user').with_traversal_keys

vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

vim.keymap.set({ 'n', 'x', 'o' }, '<cr>', function()
  leap.leap({
    ['repeat'] = true,
    opts = clever('<cr>', '<bs>'),
  })
end)
vim.keymap.set({ 'n', 'x', 'o' }, '<bs>', function()
  leap.leap({
    ['repeat'] = true,
    opts = clever('<bs>', '<cr>'),
    backward = true,
  })
end)

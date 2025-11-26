local keymap = vim.keymap
local leap = require('leap').leap
local clever_s = require('leap.user').with_traversal_keys('s', 'S')
keymap.set({ 'n', 'x', 'o' }, 's', function()
  leap({ opts = clever_s })
end)
keymap.set({ 'n', 'x', 'o' }, 'S', function()
  leap({ opts = clever_s, backward = true })
end)

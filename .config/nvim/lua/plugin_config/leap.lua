local keymap = vim.keymap

keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
keymap.set('n', 'S', '<Plug>(leap-from-window)')

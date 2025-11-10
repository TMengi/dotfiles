local keymap = vim.keymap
keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
keymap.set('n',             'S', '<Plug>(leap-from-window)')

-- Set traversal keys to repeat previous motion
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

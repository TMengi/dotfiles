local keymap = vim.keymap

local opts = { silent = true, noremap = true }
keymap.set('n', '<leader>l', ':Format<cr>', opts) -- Format whole buffer
keymap.set('x', '<leader>l', ':Format<cr>', opts) -- Format selection

require('formatter').setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = {
      require('formatter.filetypes.lua').stylua,
    },
    python = {
      require('formatter.filetypes.python').yapf,
    },
    rust = {
      require('formatter.filetypes.rust').rustfmt,
    },
    ['*'] = {
      require('formatter.filetypes.any').remove_trailing_whitespace,
    },
  },
})

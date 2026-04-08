local keymap = vim.keymap

local opts = { silent = true, noremap = true }
keymap.set('n', '<leader>l', ':Format<cr>', opts) -- Format whole buffer

require('formatter').setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = {
      require('formatter.filetypes.lua').stylua,
    },
    python = {
      require('formatter.filetypes.python').ruff,
    },
    rust = {
      require('formatter.filetypes.rust').rustfmt,
    },
    cpp = {
      require('formatter.filetypes.cpp').clangformat,
    },
    proto = {
      require('formatter.filetypes.cpp').clangformat,
    },
    json = {
      require('formatter.filetypes.json').jq,
    },
    ['*'] = {
      require('formatter.filetypes.any').remove_trailing_whitespace,
    },
  },
})

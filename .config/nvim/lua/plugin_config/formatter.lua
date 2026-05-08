local keymap = vim.keymap

local opts = { silent = true, noremap = true }
keymap.set('n', '<leader>l', ':Format<cr>', opts) -- Format whole buffer

-- The available configurations live in
-- ~/.local/share/nvim/lazy/formatter.nvim/lua/formatter
require('formatter').setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    ['*'] = {
      require('formatter.filetypes.any').remove_trailing_whitespace,
    },
    cpp = {
      require('formatter.filetypes.cpp').clangformat,
    },
    json = {
      require('formatter.filetypes.json').jq,
    },
    lua = {
      require('formatter.filetypes.lua').stylua,
    },
    proto = {
      require('formatter.filetypes.cpp').clangformat,
    },
    python = {
      require('formatter.filetypes.python').ruff,
    },
    rust = {
      require('formatter.filetypes.rust').rustfmt,
    },
    sh = {
      require('formatter.filetypes.sh').shfmt,
    },
    yaml = {
      require('formatter.filetypes.yaml').prettier,
    },
    ['yaml.ansible'] = {
      require('formatter.filetypes.yaml').prettier,
    },
    zsh = {
      require('formatter.filetypes.sh').shfmt,
    },
  },
})

-- Note that the tree-sitter-cli appears to no longer be installed
-- automatically. Use :checkhealth nvim-treesitter to see if it is available,
-- and rectify with `cargo install --locked tree-sitter-cli` if necessary

local api = vim.api
local fn = vim.fn
local treesitter = require('nvim-treesitter')
local configs = require('nvim-treesitter.configs')

local languages = {
  'bash',
  'cpp',
  'json',
  'lua',
  'markdown',
  'python',
  'regex',
  'rust',
  'toml',
  'vim',
  'yaml',
}

treesitter.setup({
  install_dir = fn.stdpath('data') .. '/site',
})
configs.setup({
  ensure_installed = languages,
  auto_install = true,
})

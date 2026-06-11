-- Note that the tree-sitter-cli needs to be installed separately. Use
-- :checkhealth nvim-treesitter to see if it is available, and rectify with
-- `cargo install --locked tree-sitter-cli` if necessary

local fn = vim.fn
local treesitter = require('nvim-treesitter')

local languages = {
  'bash',
  'cpp',
  'json',
  'lua',
  'markdown',
  'proto',
  'python',
  'regex',
  'rust',
  'ssh_config',
  'toml',
  'vim',
  'yaml',
}

treesitter.setup({
  install_dir = fn.stdpath('data') .. '/site',
})
treesitter.install(languages)

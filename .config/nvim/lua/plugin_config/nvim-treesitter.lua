-- Note that the tree-sitter-cli needs to be installed separately. Use
-- :checkhealth nvim-treesitter to see if it is available, and rectify with
-- `cargo install --locked tree-sitter-cli` if necessary

local fn = vim.fn
local treesitter = require('nvim-treesitter')

local languages = {
  'bash',
  'cpp',
  'dockerfile',
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
  'zsh',
}

treesitter.setup({
  install_dir = fn.stdpath('data') .. '/site',
})
treesitter.install(languages)

-- Automatically start highlighting
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

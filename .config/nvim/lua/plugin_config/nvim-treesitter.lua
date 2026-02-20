-- Note that the tree-sitter-cli appears to no longer be installed
-- automatically. Use :checkhealth nvim-treesitter to see if it is available,
-- and rectify with `cargo install --locked tree-sitter-cli` if necessary

local api = vim.api
local fn = vim.fn
local treesitter = require('nvim-treesitter')

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
treesitter.install(languages):wait(300000) -- wait for up to 5 minutes to compile parsers
api.nvim_create_autocmd('FileType', {
  pattern = languages,
  callback = function()
    vim.treesitter.start()
  end,
})

-- Allows us to wholesale require('plugin_config') in the main init.lua

-- Put new files in here, .lua config paths relative to config_dir
local config_dir = 'plugin_config'
local plugin_names = {
  'colorscheme',
  'comment',
  'formatter',
  'git-blame',
  'indentline',
  'lazygit',
  'leap',
  'lsp',
  'lualine',
  'nvim-autopairs',
  'nvim-cmp',
  'nvim-tree',
  'nvim-treesitter',
  'rust-tools',
  'telescope',
  'vim-gitgutter',
}

for _, name in pairs(plugin_names) do
  require(config_dir .. '.' .. name)
end

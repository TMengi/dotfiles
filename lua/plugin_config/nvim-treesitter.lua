require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'cpp',
    'lua',
    'python',
    'rust',
    'vim',
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
})

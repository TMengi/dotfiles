require('nvim-treesitter.config').setup({
  ensure_installed = {
    'cpp',
    'lua',
    'markdown',
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

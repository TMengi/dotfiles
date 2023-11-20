require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'gruvbox', -- Should I be using 'auto'?
  },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
      },
    },
    lualine_b = {
      'diff',
      {
        'diagnostics',
        sources = {
          'nvim_diagnostic',
          'nvim_lsp',
        },
      },
    },
    lualine_c = {},
  },
  extensions = { 'nvim-tree' },
})

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
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
          -- 'nvim_diagnostic', Seems to raise the same errors as nvim_lsp
          'nvim_lsp',
        },
      },
    },
    lualine_c = {},
  },
  extensions = { 'nvim-tree' },
})

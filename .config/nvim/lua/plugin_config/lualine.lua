local noice_api = require('noice').api

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
      'diagnostics',
    },
    lualine_c = {},
    lualine_x = {
      -- Move status and command messages from noice into statusline
      {
        noice_api.status.message.get_hl,
        cond = noice_api.status.message.has,
      },
      {
        noice_api.status.command.get,
        cond = noice_api.status.command.has,
        color = { fg = '#ff9e64' },
      },
      'searchcount',
      'encoding',
      'fileformat',
      'filetype',
      'lsp_status',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { 'nvim-tree' },
})

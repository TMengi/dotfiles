-- Colorscheme configuration

require('catppuccin').setup({
  flavour = 'macchiato',
  dim_inactive = {
    enabled = true,
  },
  integrations = {
    cmp = true,
    dap = true,
    dap_ui = true,
    gitgutter = true,
    leap = true,
    mason = true,
    nvimtree = true,
    telescope = { enabled = true },
    treesitter = true,
  },
})
vim.cmd.colorscheme('catppuccin-nvim')

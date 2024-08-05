-- Colorscheme configuration

-- vim.opt.termguicolors = true
-- vim.cmd.colorscheme('gruvbox')

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
vim.cmd.colorscheme('catppuccin')

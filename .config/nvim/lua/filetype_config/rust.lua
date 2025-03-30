local api = vim.api
local opt_local = vim.opt_local

api.nvim_create_autocmd('FileType', {
  desc = 'Rust allows longer line lengths',
  pattern = 'rust',
  callback = function()
    opt_local.textwidth = 99
    opt_local.colorcolumn = '100'
  end,
})

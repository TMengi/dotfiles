local api = vim.api

-- Command to print the outline of a python file
api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    api.nvim_create_user_command('PyOutline', [[g/\v^\s{,4}(class|def)/p]], {})
  end,
})

-- Command to open the pyrightconfig
api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  command = 'map <leader>y :tabnew pyrightconfig.json<cr>',
})


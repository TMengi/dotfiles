local api = vim.api

-- Command to print the outline of a python file
api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- TODO: Can I turn this into qflist entries? Then I could open the results
    -- in a picker and click through docstrings/jump to locations. That would
    -- be so sick
    api.nvim_create_user_command('PyOutline', [[g/\v^\s{,4}(class|def)/p]], {})
  end,
})

-- Command to open the pyrightconfig
api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  command = 'map <leader>y :tabnew pyrightconfig.json<cr>',
})

local api = vim.api
local keymap = vim.keymap

api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- Command to print the outline of a python file
    -- TODO: Can I turn this into qflist entries? Then I could open the results
    -- in a picker and click through docstrings/jump to locations. That would
    -- be so sick
    api.nvim_create_user_command('PyOutline', [[g/\v^\s{,4}(class|def)\s\S+(\(|:)/p]], {})

    -- Command to open the pyrightconfig
    keymap.set('n', '<leader>y', ':tabnew pyrightconfig.json<cr>', { buffer = true })

    -- Ruff formating and import sorting
    keymap.set('n', '<leader>i', ':!ruff check --select I --fix<cr>', { buffer = true, silent = true })
  end,
})

-- Generic FileType, syntax, and commentstring configuration
local api = vim.api
local opt_local = vim.opt_local

-- Set the filetype for some uncommon extensions
local buffer_events = { 'BufNewFile', 'BufEnter', 'BufRead' }
local filetype_like = function(file_pattern, desired_filetype)
  -- Sets the filetype for ``file_pattern`` files to be ``desired_filetype``
  api.nvim_create_autocmd(buffer_events, {
    pattern = file_pattern,
    callback = function()
      opt_local.filetype = desired_filetype
    end,
  })
end
filetype_like('BUILD.pants', 'pants')
filetype_like('*.script', 'matlab') -- Pretend GMAT scripts are matlab
filetype_like('*.prototxt', 'prototxt')
filetype_like('*.sim', 'yaml')

-- Explicitly set syntax for certain uncommon filetypes
local highlight_like = function(pattern, desired_syntax)
  -- Highlights `pattern` files like they are `desired_syntax` files
  api.nvim_create_autocmd(buffer_events, {
    pattern = pattern,
    callback = function()
      opt_local.syntax = desired_syntax
    end,
  })
end
highlight_like('*.prototxt', 'yaml')
highlight_like('BUILD.pants', 'python')
highlight_like('.local_zshrc', 'zsh')

-- Explicitly set the comment string for certain uncommon filetypes
local set_commentstring = function(filetype, commentstring)
  api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function()
      opt_local.commentstring = commentstring .. ' %s'
    end,
  })
end
set_commentstring('pants', '#')
set_commentstring('prototxt', '#')
set_commentstring('kdl', '//')

-- Try to detect ansible-flavored yaml files
api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    if vim.fn.search('^- \\(hosts\\|name\\):', 'wn') ~= 0 then
      opt_local.filetype = 'yaml.ansible'
    end
  end,
})

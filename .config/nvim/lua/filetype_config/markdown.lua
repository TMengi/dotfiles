local api = vim.api
local keymap = vim.keymap

-- Checkmark toggling in markdown files
local markdown_toggle_check = function()
  local row, _ = unpack(api.nvim_win_get_cursor(0))
  local current_line = api.nvim_get_current_line()
  local new_line = ''
  -- TODO: Try to clean this up
  if string.find(current_line, '^%s*- %[ %]') then
    new_line = string.gsub(current_line, '%[ %]', '[x]', 1)
  elseif string.find(current_line, '^%s*- %[x%]') then
    new_line = string.gsub(current_line, '%[x%]', '[ ]', 1)
  elseif string.find(current_line, '^%s*-%s*') then
    new_line = string.gsub(current_line, '-%s*', '- [ ] ', 1)
  else
    local i, j = string.find(current_line, '^%s*')
    assert(i ~= nil)
    new_line = string.sub(current_line, i, j) .. string.gsub(current_line, '^%s*', '- [ ] ')
  end
  api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
end
api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    api.nvim_create_user_command('MarkdownToggleCheck', markdown_toggle_check, {})
    keymap.set('n', '<leader>ll', ':MarkdownToggleCheck<cr>', { silent = true, noremap = true })
  end,
})

--[[
Functions to open all quickfix items in various splits
--]]
local M = {}

--- Opens all items in the qflist with the provided command
---@param command string: Command with which to open each item in the qflist
local wrapped_qfopen_with = function(command)
  return function()
    vim.cmd.cfdo('silent ' .. command .. ' %')
    vim.cmd.quit()
    vim.cmd.cclose()
  end
end

-- TODO: Some typehinting on these would be nice
M.qfopen_split = wrapped_qfopen_with('sp')
M.qfopen_vsplit = wrapped_qfopen_with('vs')
M.qfopen_tab = wrapped_qfopen_with('tabnew')

return M

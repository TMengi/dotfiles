-- FileType specific configurations, keymaps, etc.

local config_dir = 'filetype_config'
local languages = {
  'markdown',
  'python',
  'rust',
}

for _, name in pairs(languages) do
  require(config_dir .. '.' .. name)
end

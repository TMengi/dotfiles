local config_dir = 'filetype_config'
local languages = {}

for _, name in pairs(languages) do
  require(config_dir .. '.' .. name)
end

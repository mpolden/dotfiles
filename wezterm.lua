local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Theme
config.color_scheme = 'DoomOne'

-- Font
config.font = wezterm.font 'Iosevka'
config.font_size = 16.0

-- Keybindings
local act = wezterm.action

-- Use left option as compose so that OPT-7 results in pipe (default is false)
config.send_composed_key_when_left_alt_is_pressed = true

-- Use CMD as OPT for common readline shortcuts
config.keys = {
  {
    key = 'b',
    mods = 'CMD',
    action = act.SendKey { key = 'b', mods = 'OPT' },
  },
  {
    key = 'f',
    mods = 'CMD',
    action = act.SendKey { key = 'f', mods = 'OPT' },
  },
  {
    key = 'd',
    mods = 'CMD',
    action = act.SendKey { key = 'd', mods = 'OPT' },
  },
  {
    key = 'x',
    mods = 'CMD',
    action = act.SendKey { key = 'x', mods = 'OPT' },
  },
}

-- Local config (optional)
local loaded, local_config = pcall(require, "local")
if loaded then
  for k, v in pairs(local_config) do
    config[k] = v
  end
end

return config

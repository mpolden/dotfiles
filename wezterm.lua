-- -*- lua-indent-level: 2 -*-

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Theme
config.color_scheme = 'DoomOne'

-- Font
config.font = wezterm.font('Iosevka', { weight = 'Medium' })
config.font_size = 14.0

-- Tab bar
config.window_frame = { font_size = config.font_size }

-- Hide title bar
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"

-- Keybindings
local act = wezterm.action

-- Use left option as compose so that OPT-7 results in pipe (default is false)
config.send_composed_key_when_left_alt_is_pressed = true

-- Disable dead keys so that ~ is produced immediately
config.use_dead_keys = false

-- See https://wezfurlong.org/wezterm/config/keyboard-concepts.html#macos-left-and-right-option-key
-- for more details on the above

config.keys = {
  -- Use CMD as OPT for common readline shortcuts
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
  -- Search with C-s
  {
    key = 's',
    mods = 'CTRL',
    action = act.Search 'CurrentSelectionOrEmptyString'
  },
}

-- Extend copy mode keybindings with Emacs-style bindings
config.key_tables = {
  copy_mode = wezterm.gui.default_key_tables().copy_mode,
  search_mode = wezterm.gui.default_key_tables().search_mode,
}
copy_mode_emacs = {
  -- Navigation
  { key = 'b', mods = 'CMD', action = act.CopyMode 'MoveBackwardWord' },
  { key = 'f', mods = 'CMD', action = act.CopyMode 'MoveForwardWord' },
  { key = 'b', mods = 'CTRL', action = act.CopyMode 'MoveLeft' },
  { key = 'f', mods = 'CTRL', action = act.CopyMode 'MoveRight' },
  { key = 'p', mods = 'CTRL', action = act.CopyMode 'MoveUp' },
  { key = 'n', mods = 'CTRL', action = act.CopyMode 'MoveDown' },
  { key = 'a', mods = 'CTRL', action = act.CopyMode 'MoveToStartOfLine' },
  { key = 'e', mods = 'CTRL', action = act.CopyMode 'MoveToEndOfLineContent' },
  -- Selection
  { key = 'Space', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Cell' } },
  -- Copy
  {
    key = 'w',
    mods = 'CMD',
    action = act.Multiple {
      { CopyTo = 'ClipboardAndPrimarySelection' },
      act.ClearSelection,
    },
  },
}
for _, key in pairs(copy_mode_emacs) do
  table.insert(config.key_tables.copy_mode, key)
end

-- Extend search mode keybindings with Emacs-style bindings
search_mode_emacs = {
  { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
  { key = 's', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
  { key = 'r', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
}
for _, key in pairs(search_mode_emacs) do
  table.insert(config.key_tables.search_mode, key)
end

-- Local config (optional)
local loaded, local_config = pcall(require, "local")
if loaded then
  for k, v in pairs(local_config) do
    config[k] = v
  end
end

return config

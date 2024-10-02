-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colors & Font
config.color_scheme = "Catppuccin Mocha"
config.font_size = 14.2
config.font = wezterm.font("FiraMono Nerd Font")
config.colors = {
  background = "#191919",
  tab_bar = {
    background = "#191919"
  }
}

-- Tabs
config.enable_tab_bar = true
config.show_tabs_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Window
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  active_titlebar_bg = "#191919",
}
config.initial_cols = 140
config.initial_rows = 75

config.adjust_window_size_when_changing_font_size = false

-- Debugging
--config.debug_key_events = true
--config.disable_default_key_bindings = true

-- A fix for https://github.com/wez/wezterm/issues/4706
-- Removes line breaks on wrapped lines inside Tmux
wezterm.on('log-selection', function(window, pane)
  local sel = window:get_selection_text_for_pane(pane)
  local str = sel:gsub("\r?\n", "")
  window:copy_to_clipboard(str, 'Clipboard')
end)

-- Key mappings
local act = wezterm.action
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow",  mods = "OPT",   action = act.SendString("\x1bb") },

  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT",   action = act.SendString("\x1bf") },

  { key = "Home",       mods = "NONE",  action = act.SendString("\001") },
  { key = "End",        mods = "NONE",  action = act.SendString("\005") },

  { key = "+",          mods = "CMD",   action = act.IncreaseFontSize },

  -- Beware: Home/End buttons behave differently inside tmux
  { key = "LeftArrow",  mods = "CMD",   action = wezterm.action.SendString('\x1b[H') },
  { key = "RightArrow", mods = "CMD",   action = wezterm.action.SendString('\x1b[F') },

  { key = "c",          mods = "SUPER", action = act.EmitEvent 'log-selection' }
}

-- config.send_composed_key_when_left_alt_is_pressed = true
-- config.send_composed_key_when_right_alt_is_pressed = true

-- Plugins
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    theme = 'Catppuccin Mocha',
  },
  sections = {
    tabline_x = {},
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'hostname' },
  }

})

return config

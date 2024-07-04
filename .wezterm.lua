-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font_size = 14.2
config.font = wezterm.font("FiraMono Nerd Font")
config.colors = {
	background = "#191919",
}
config.enable_tab_bar = false
-- config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_frame = {
	active_titlebar_bg = "#191919",
}

--config.debug_key_events = true
--config.disable_default_key_bindings = true

config.adjust_window_size_when_changing_font_size = false

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.canonicalize_pasted_newlines = "None"

-- Key mappings
local act = wezterm.action
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },

	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

	{ key = "Home", mods = "NONE", action = act.SendString("\001") },
	{ key = "End", mods = "NONE", action = act.SendString("\005") },

	{ key = "+", mods = "CMD", action = wezterm.action.IncreaseFontSize },
}

return config

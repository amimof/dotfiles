-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colors & Font
-- config.color_scheme = "Tokyo Night"
config.color_scheme = "Eldritch"
config.font_size = 13
config.font = wezterm.font("FiraMono Nerd Font")
config.colors = {
	background = "#11121D",
	tab_bar = {
		background = "#16161e",
	},
}

config.max_fps = 170

-- Tabs
config.tab_max_width = 26
config.enable_tab_bar = true
config.show_tabs_in_tab_bar = true
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

--config.send_composed_key_when_left_alt_is_pressed = true
--config.send_composed_key_when_right_alt_is_pressed = true

-- Debugging
--config.debug_key_events = true
--config.disable_default_key_bindings = true

local act = wezterm.action

local function is_nvim(pane)
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local function is_zoomed(pane)
	local panes = pane:tab():panes_with_info()
	local isZoomed = false
	for _, p in ipairs(panes) do
		if p.is_zoomed then
			isZoomed = true
		end
	end
	return isZoomed
end

local function split_nav(resize_or_move, mods, key, dir)
	local event = "SplitNav_" .. resize_or_move .. "_" .. dir
	wezterm.on(event, function(win, pane)
		if is_nvim(pane) then
			-- pass the keys through to vim/nvim
			win:perform_action({ SendKey = { key = key, mods = mods } }, pane)
		else
			if resize_or_move == "resize" then
				win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
			else
				local zoomed = is_zoomed(pane)
				win:perform_action({ ActivatePaneDirection = dir }, pane)
				win:perform_action({ SetPaneZoomState = zoomed }, pane)
			end
		end
	end)
	return {
		key = key,
		mods = mods,
		action = act.EmitEvent(event),
	}
end

-- Global modifier key
local mod = "SHIFT|SUPER"

-- Key mappings
config.keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },

	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

	-- CMD+Left/right goes to end/beginning of line
	{ key = "LeftArrow", mods = "SUPER", action = act.SendString("\001") },
	{ key = "RightArrow", mods = "SUPER", action = act.SendString("\005") },

	-- Switch to the default workspace
	{
		key = "y",
		mods = mod,
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},

	-- Scrollback
	{ mods = mod, key = "u", action = act.ScrollByPage(-0.5) },
	{ mods = mod, key = "d", action = act.ScrollByPage(0.5) },

	-- Quick select
	{ mods = mod, key = "S", action = act.QuickSelect },

	-- Cycle workspaces
	{ mods = mod, key = "RightBracket", action = act.SwitchWorkspaceRelative(1) },
	{ mods = mod, key = "å", action = act.SwitchWorkspaceRelative(-1) },

	-- Rotate tabs
	{ mods = mod, key = "R", action = act.RotatePanes("Clockwise") },

	-- Cycle tabs
	{ mods = "SUPER", key = "RightBracket", action = act.ActivateTabRelative(1) },
	{ mods = "SUPER", key = "å", action = act.ActivateTabRelative(-1) },

	-- Go to previously active pane
	{ mods = mod, key = "a", action = act.ActivateLastTab },

	-- Split panes
	{ mods = mod, key = "h", action = act.SplitHorizontal },
	{ mods = mod, key = "v", action = act.SplitVertical },

	-- Zoom in on pane
	{ mods = mod, key = "Enter", action = act.TogglePaneZoomState },

	-- Resize panes
	{ mods = mod, key = "UpArrow", action = act.AdjustPaneSize({ "Up", 4 }) },
	{ mods = mod, key = "DownArrow", action = act.AdjustPaneSize({ "Down", 4 }) },
	{ mods = mod, key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 4 }) },
	{ mods = mod, key = "RightArrow", action = act.AdjustPaneSize({ "Right", 4 }) },

	-- Copy mode
	{ mods = mod, key = "X", action = wezterm.action.ActivateCopyMode },

	-- Show the launcher in fuzzy selection mode and have it list all workspaces and allow activating one.
	{ key = "l", mods = mod, action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "n",
		mods = mod,
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{ mods = mod, key = "P", action = wezterm.action.ActivateCommandPalette },
	{ mods = mod, key = "T", action = wezterm.action.ShowTabNavigator },

	-- move between split panes
	split_nav("move", "CTRL", "h", "Left"),
	split_nav("move", "CTRL", "j", "Down"),
	split_nav("move", "CTRL", "k", "Up"),
	split_nav("move", "CTRL", "l", "Right"),
}

-- Plugins
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		theme = "Eldritch",
		tab_separators = {
			left = "",
			right = "",
		},
		theme_overrides = {
			tab = {
				active = { bg = "#212234", fg = "white" },
				inactive = { bg = "#16161e", fg = "grey" },
			},
		},
	},
	sections = {
		tab_active = {
			{ Attribute = { Intensity = "Normal" } },
			{ Background = { Color = "#ffc777" } },
			{ Foreground = { Color = "#1f2335" } },
			"▎",
			"ResetAttributes",
			"index",
			{ "zoomed", padding = { left = 0, right = 1 } },
			{ "process", padding = { left = 0, right = 2 } },
		},
		tab_inactive = {
			{ Attribute = { Intensity = "Normal" } },
			{ Background = { Color = "grey" } },
			{ Foreground = { Color = "#1f2335" } },
			"▎",
			"ResetAttributes",
			"index",
			{ "zoomed", padding = { left = 0, right = 1 } },
			{ "process", padding = { left = 0, right = 2 } },
		},
		tabline_b = {},
		tabline_x = {},
		tabline_y = {},
		tabline_z = { "workspace" },
	},
})

return config

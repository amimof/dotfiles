-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- local show_timestamp_in_status_bar = false
-- local show_cwd_in_status_bar = false
-- local show_hostname_in_status_bar = true
-- local show_battery_in_status_bar = true
-- local show_k8scontext_in_status_bar = true

local status_bar = {
  datetime = {
    enabled = true,
    icon = '󰃰'
  },
  battery = {
    enabled = true,
    icon = '󰁿'
  },
  host = {
    enabled = true,
    icon = '󰒋'
  },
  user = {
    enabled = true,
    icon = ''
  },
  directory = {
    enabled = true,
    icon = ''
  },
  kubernetes = {
    enabled = true,
    icon = ''
  }
}
local text_fg = '#cdd6f4'
local text_bg = '#313244'
local icon_bg = '#a6e3a1'
local tabs_bg = '#1e1e2e'

config.color_scheme = "Catppuccin Mocha"
config.font_size = 14.2
config.font = wezterm.font("FiraMono Nerd Font")
config.colors = {
  background = "#191919",
  tab_bar = {
    background = tabs_bg
  }
}
config.enable_tab_bar = true
config.show_tabs_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
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

--config.debug_key_events = true
--config.disable_default_key_bindings = true

config.adjust_window_size_when_changing_font_size = false

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Status bar widgets
wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''
    local hostname = ''

    if type(cwd_uri) == 'userdata' then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wezterm.hostname()
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find '/'
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        -- and extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    -- Remove the domain name portion of the hostname
    local dot = hostname:find '[.]'
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    if status_bar.directory.enabled then
      table.insert(cells, { text = cwd, icon = status_bar.directory.icon })
    end

    if status_bar.host.enabled then
      table.insert(cells, { text = hostname, icon = status_bar.host.icon })
    end
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  if status_bar.datetime.enabled then
    local date = wezterm.strftime '%a %b %-d %H:%M'
    table.insert(cells, { text = date, icon = status_bar.datetime.icon })
  end

  -- An entry for each battery (typically 0 or 1 battery)
  if status_bar.battery.enabled then
    for _, b in ipairs(wezterm.battery_info()) do
      table.insert(cells, { text = string.format('%.0f%%', b.state_of_charge * 100), icon = status_bar.battery.icon })
    end
  end

  -- k8s context
  if status_bar.kubernetes.enabled then
    local handle = io.popen("/opt/homebrew/bin/kubectl config current-context")
    local result = handle:read("*a")
    handle:close()
    local str = utf8.char(0x2388) .. result
    table.insert(cells, { text = str, icon = status_bar.kubernetes.icon })
  end

  -- The powerline < symbol
  local LEFT_SEPARATOR = ''

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(conf, is_last)
    table.insert(elements, { Background = { Color = text_bg } })
    table.insert(elements, { Foreground = { Color = icon_bg } })
    table.insert(elements, { Text = LEFT_SEPARATOR })
    --
    table.insert(elements, { Background = { Color = '#a6e3a1' } })
    table.insert(elements, { Foreground = { Color = text_bg } })
    table.insert(elements, { Text = conf.icon .. ' ' })
    --
    table.insert(elements, { Background = { Color = '#313244' } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. conf.text .. ' ' })
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

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

  { key = "c",          mods = "SUPER", action = act.EmitEvent 'log-selection' }
}

return config

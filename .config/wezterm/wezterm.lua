local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("Monaco")
config.font_size = 18.0

-- For example, changing the color scheme:

config.keys = {
	-- Clears the scrollback and viewport leaving the prompt line the new first line.
	{
		key = "k",
		mods = "CMD",
		action = act.ClearScrollback("ScrollbackAndViewport"),
	},
}

-- and finally, return the configuration to wezterm
return config

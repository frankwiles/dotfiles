-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("Monaco")
config.font_size = 18.0

-- For example, changing the color scheme:

-- and finally, return the configuration to wezterm
return config

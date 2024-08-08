local wezterm = require("wezterm")
local tab_bar = require("tab_bar")
local colors = require("colors")
local keys_bindings = require("key_bindings")
local act = wezterm.action
local color_scheme = colors.color_scheme

local config = wezterm.config_builder()
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.keys = keys_bindings.keys

config.color_scheme = color_scheme
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.font = wezterm.font("MonoLisa", { weight = "Regular" })
config.font_size = 16
config.adjust_window_size_when_changing_font_size = true
config.native_macos_fullscreen_mode = true
config.tab_max_width = 32
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

local tab_bar_theme = tab_bar.extract_tab_bar_colors_from_theme(color_scheme)
config.colors = {
	tab_bar = tab_bar_theme.tab_bar_colors,
}
config.window_background_opacity = 0.90

config.tab_bar_at_bottom = true
config.font_size = 16.0
config.use_fancy_tab_bar = true

return config

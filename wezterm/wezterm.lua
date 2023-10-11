local wezterm = require("wezterm")

local config = {
	-- window_background_opacity = 0.15,
	macos_window_background_blur = 30,
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	-- font = wezterm.font("Rec Mono Duotone", { weight = "Regular" }),
	font = wezterm.font("MonoLisa", { weight = "Regular" }),
	font_size = 16,
	adjust_window_size_when_changing_font_size = true,
	native_macos_fullscreen_mode = true,
	keys = {
		{
			key = "n",
			mods = "SHIFT|CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
}

local appearance = wezterm.gui.get_appearance()

if appearance:find("Dark") then
	local colors_moon = require("/Users/jamesbest/dotfiles/wezterm/lua/rose-pine-moon").colors()
	local window_frame_moon = require("/Users/jamesbest/dotfiles/wezterm/lua/rose-pine-moon").window_frame()
	config.colors = colors_moon
	config.window_frame = window_frame_moon
else
	local colors_moon = require("/Users/jamesbest/dotfiles/wezterm/lua/rose-pine-dawn").colors()
	local window_frame_moon = require("/Users/jamesbest/dotfiles/wezterm/lua/rose-pine-dawn").window_frame()
	config.colors = colors_moon
	config.window_frame = window_frame_moon
end
config.window_background_opacity = 0.90
return config

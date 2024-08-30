local wezterm = require("wezterm")
local tab_bar = require("tab_bar")
local colors = require("colors")
local keys_bindings = require("key_bindings")

local config = wezterm.config_builder()
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

function detect_host_os()
	-- package.config:sub(1,1) returns '\' for windows and '/' for *nix.
	if package.config:sub(1, 1) == "\\" then
		return "windows"
	else
		-- uname should be available on *nix systems.
		local check = io.popen("uname -s")
		local result = check:read("*l")
		check:close()

		if result == "Darwin" then
			return "macos"
		else
			return "linux"
		end
	end
end

local host_os = detect_host_os()

if host_os == "macos" then
	-- check homebrew binary symlinks on startup.
	config.set_environment_variables = {
		PATH = "/opt/homebrew/bin/:" .. os.getenv("PATH"),
	}
end

config.keys = keys_bindings.keys

config.color_scheme = colors.color_scheme
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
local font = wezterm.font("MonoLisa", { weight = "Regular" })
config.font = font
config.font_size = 16
config.adjust_window_size_when_changing_font_size = true
config.native_macos_fullscreen_mode = true
config.tab_max_width = 32
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

local tab_bar_theme = tab_bar.extract_tab_bar_colors_from_theme(colors.color_scheme)
-- config.window_frame = tab_bar.merge_tables({
-- 	font = wezterm.font(font, { weight = "DemiBold" }),
-- 	font_size = 14,
-- }, tab_bar_theme.window_frame_colors)
config.colors = {
	tab_bar = tab_bar_theme.tab_bar_colors,
}
-- config.window_background_opacity = 0.90

return config

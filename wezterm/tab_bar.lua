local wezterm = require("wezterm")
local act = wezterm.action

-- How to create module: https://wezfurlong.org/wezterm/config/files.html?h=modules#making-your-own-lua-modules
local module = {}

-- Issue: https://github.com/wez/wezterm/issues/2854
local extract_tab_bar_colors_from_theme = function(theme_name)
	local wez_theme = wezterm.color.get_builtin_schemes()[theme_name]
	return {
		window_frame_colors = {
			active_titlebar_bg = wez_theme.background,
			inactive_titlebar_bg = wezterm.color.parse(wez_theme.background):darken(0.8),
		},
		tab_bar_colors = {
			inactive_tab_edge = wezterm.color.parse(wez_theme.background):darken(0.8),
			active_tab = {
				bg_color = wez_theme.brights[5],
				fg_color = wez_theme.background,
			},
			inactive_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			inactive_tab_hover = {
				bg_color = wezterm.color.parse(wez_theme.background):lighten(0.1),
				fg_color = wezterm.color.parse(wez_theme.foreground):lighten(0.2),
			},
			new_tab = {
				bg_color = wez_theme.background,
				fg_color = wez_theme.foreground,
			},
			new_tab_hover = {
				bg_color = wez_theme.brights[3],
				fg_color = wez_theme.background,
			},
		},
	}
end

local merge_tables = function(first_table, second_table)
	for k, v in pairs(second_table) do
		first_table[k] = v
	end
	return first_table
end

-- https://github.com/wez/wezterm/issues/522
local keys = {
	{
		key = "I",
		mods = "SUPER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

module.extract_tab_bar_colors_from_theme = extract_tab_bar_colors_from_theme
module.merge_tables = merge_tables
module.keys = keys

return module

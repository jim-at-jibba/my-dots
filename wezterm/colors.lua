local wezterm = require("wezterm")

-- https://wezfurlong.org/wezterm/config/lua/wezterm.gui/get_appearance.html
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "rose-pine"
	else
		return "rose-pine-dawn"
	end
end

return {
	color_scheme = scheme_for_appearance(get_appearance()),
}

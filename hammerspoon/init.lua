require("keyboard.yabai")
require("keyboard.window")

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.alert.show("Fuck")
end)

require("keyboard.yabai")
hs.notify.new({ title = "Hammerspoon", informativeText = "Ready to rock!! 🤘" }):send()

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.alert.show("Fuck")
end)

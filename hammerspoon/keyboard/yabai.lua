-- Send message(s) to a running instance of yabai.
local function yabai(commands)
	for _, cmd in ipairs(commands) do
		os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
	end
end

local function alt(key, commands)
	hs.hotkey.bind({ "alt" }, key, function()
		yabai(commands)
	end)
end

-- alpha
alt("f", { "window --toggle zoom-fullscreen" })
alt("l", { "space --focus recent" })
alt("m", { "space --toggle mission-control" })
alt("p", { "window --toggle pip" })
alt("g", { "space --toggle padding", "space --toggle gap" })
alt("e", { "space --balance" })
alt("r", { "space --rotate 90" })
alt("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
alt("'", { "space --layout stack" })
alt(";", { "space --layout bsp" })
alt("tab", { "space --focus recent" })

local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

local function hyper(key, commands)
	hs.hotkey.bind({ "cmd", "alt", "ctrl" }, key, function()
		yabai(commands)
	end)
end

hs.hotkey.bind({ "rightcmd" }, "1", function()
	hs.eventtap.keyStroke({}, "`")
end)

for i = 1, 9 do
	local num = tostring(i)
	alt(num, { "space --focus " .. num })
	altShiftNumber(num)
end

local homeRow = { h = "west", j = "south", k = "north", l = "east" }

for key, direction in pairs(homeRow) do
	alt(key, { "window --focus " .. direction })
	altShift(key, { "window --swap " .. direction })
	-- hyper(key, { "window --swap " .. direction })
end

-- resize
hyper("h", { "window --resize left:-50:0", "window --resize right:-50:0" })
hyper("j", { "window --resize bottom:0:50", "window --resize top:0:50" })
hyper("k", { "window --resize top:0:-50", "window --resize bottom:0:-50" })
hyper("l", { "window --resize right:50:0", "window --resize left:50:0" })

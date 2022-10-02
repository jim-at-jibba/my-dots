set theFile to POSIX file "/Users/jamesbest/Documents/backgrounds/bappie-L_rNhnpWkD0-unsplash.jpg" -- just an example

-- Find out how many desktops you have:
tell application "System Preferences"
	reveal anchor "shortcutsTab" of pane id "com.apple.preference.keyboard"
	tell application "System Events" to tell window "Keyboard" of process "System Preferences"
		set N to count (UI elements of rows of outline 1 of scroll area 2 of splitter group 1 of tab group 1 whose name begins with "Switch to Desktop")
	end tell
	quit
end tell

set numberKeys1to9 to [18, 19, 20, 21, 23, 22, 26, 28, 25] -- Key codes for 1-9 number keys

-- Loop through the desktops, setting each of their backgrounds in turn:
set k to 1
repeat while k ≤ N
	tell application "System Events" to key code (item k of numberKeys1to9) using {control down}
	delay 1
	tell application "Finder" to set desktop picture to theFile
	delay 1
	set k to (k + 1)
end repeat

if application "Sonos" is running then
  tell application "Sonos"
	set theName to track
	set theArtist to artist
	set theAblum to album
    try
      return "♫  " & theName & " - " & theArtist
    on error err
    end try
  end tell
end if

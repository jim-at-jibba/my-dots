

tm_icon=" 👾  "
tm_color_active=colour123
tm_color_inactive=colour241
tm_color_feature=colour74
tm_color_music=colour129
tm_color_session=colour92

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 250
set -g status-right-length 150
set -g status-interval 5
set -g status-justify centre

# default statusbar colors
# set-option -g status-bg colour0
set-option -g status-fg $tm_color_active
set-option -g status-bg default
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg $tm_color_inactive
set-window-option -g window-status-bg default
set -g window-status-format "#I #W"

# active window title colors
set-window-option -g window-status-current-fg $tm_color_feature
set-window-option -g window-status-current-bg default
set-window-option -g  window-status-current-format "#[bold]#I #W"

# pane border
set-option -g pane-border-fg $tm_color_inactive
set-option -g pane-active-border-fg $tm_color_session

# message text
set-option -g message-bg default
set-option -g message-fg $tm_color_active

# pane number display
set-option -g display-panes-active-colour $tm_color_session
set-option -g display-panes-colour $tm_color_inactive

# clock
set-window-option -g clock-mode-colour $tm_color_active

tm_spotify="#[fg=$tm_color_music]#(osascript ~/dotfiles/applescripts/spotify.scpt)"
#tm_itunes="#[fg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/itunes.scpt)"
#tm_rdio="#[fg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/rdio.scpt)"
#tm_battery="#(~/.dotfiles/bin/battery_indicator.sh)"
tm_vox="#[fg=$tm_color_music]#(osascript ~/dotfiles/applescripts/vox.scpt)"

tm_date="#[fg=$tm_color_inactive] %R %d %b"
tm_host="#[fg=$tm_color_feature,bold]#h"
tm_session_name="#[fg=$tm_color_session,bold]$tm_icon #S : "
tm_online="#[fg=$tm_color_feature,bold]Online: #{online_status}"
tm_ip="#[fg=$tm_color_feature]#(curl icanhazip.com) #[fg=$tm_color_music]#(ifconfig en0 | grep 'inet ' | awk '{print \"en0 \" $2}') #(ifconfig en1 | grep 'inet ' | awk '{print \"en1 \" $2}') #[fg=$tm_color_active]#(ifconfig tun0 | grep 'inet ' | awk '{print \"vpn \" $2}') "
tm_cal="#[fg=$tm_color_session]#(gcalcli --calendar='jamesg2.best@googlemail.com' agenda | head -2 | tail -1)#[default]"

set -g status-left $tm_session_name' '$tm_ip
set -g status-right $tm_vox' '$tm_spotify' '$tm_date' '$tm_online

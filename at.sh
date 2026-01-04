#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
spacebar=${dotfiles}/spacebar
sketchybar=${dotfiles}/sketchybar
kitty=${dotfiles}/kitty
tmux=${dotfiles}/tmux
ghostty=${dotfiles}/ghostty

configure_kitty() {
	cat ${kitty}/base.conf ${kitty}/${color}.conf >${dotfiles}/kitty.conf
}

configure_kick() {
	echo $1 >${dotfiles}/kick/lua/rohm/theme.lua
}

configure_ghostty() {
	cat ${ghostty}/base.conf >${ghostty}/config
	echo "theme = $1" >>${ghostty}/config
}

case $color in
rosepinemoon)
	dark-mode on
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme rose-pine")'
	configure_ghostty "Rose Pine Moon"
	;;
rosepinedawn)
	dark-mode off
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme rose-pine")'
	configure_ghostty "Rose Pine Dawn"
	;;
nightfoxdusk)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme duskfox")'
	configure_ghostty "Duskfox"
	dark-mode on
	;;
nightfoxday)
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme dayfox")'
	configure_ghostty "Dayfox"
	dark-mode off
	;;
nightfoxnord)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme nordfox")'
	configure_ghostty "Nordfox"
	dark-mode on
	;;
nightfoxtera)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme terafox")'
	configure_ghostty "Terafox"
	dark-mode on
	;;
nightfoxdawn)
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme dawnfox")'
	configure_ghostty "Dawnfox"
	dark-mode off
	;;
solarizeddark)
	dark-mode on
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme NeoSolarized")'
	configure_ghostty "Builtin Solarized Dark"
	;;
solarizedlight)
	dark-mode off
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme NeoSolarized")'
	configure_ghostty "Builtin Solarized Light"
	;;
*)
	echo "Supported colorschemes: rosepinemoon, rosepinedawn, nightfoxdusk, nightfoxday, nightfoxnord, nightfoxtera, nightfoxdawn, solarizeddark, solarizedlight"
	exit 1
	;;
esac

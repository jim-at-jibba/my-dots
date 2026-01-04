#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
spacebar=${dotfiles}/spacebar
sketchybar=${dotfiles}/sketchybar
kitty=${dotfiles}/kitty
tmux=${dotfiles}/tmux

configure_kitty() {
	cat ${kitty}/base.conf ${kitty}/${color}.conf >${dotfiles}/kitty.conf
}

configure_kick() {
	echo $1 >${dotfiles}/kick/lua/rohm/theme.lua
}

case $color in
rosepinemoon)
	dark-mode on
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme rose-pine")'
	;;
rosepinedawn)
	dark-mode off
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme rose-pine")'
	;;
nightfoxdusk)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme duskfox")'
	dark-mode on
	;;
nightfoxday)
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme dayfox")'
	dark-mode off
	;;
nightfoxnord)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme nordfox")'
	dark-mode on
	;;
nightfoxtera)
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme terafox")'
	dark-mode on
	;;
nightfoxdawn)
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme dawnfox")'
	dark-mode off
	;;
solarizeddark)
	dark-mode on
	configure_kick 'vim.cmd("set background=dark")\nvim.cmd("colorscheme NeoSolarized")'
	;;
solarizedlight)
	dark-mode off
	configure_kick 'vim.cmd("set background=light")\nvim.cmd("colorscheme NeoSolarized")'
	;;
*)
	echo "Supported colorschemes: rosepinemoon, rosepinedawn, nightfoxdusk, nightfoxday, nightfoxnord, nightfoxtera, nightfoxdawn, solarizeddark, solarizedlight"
	exit 1
	;;
esac

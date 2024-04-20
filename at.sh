#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
spacebar=${dotfiles}/spacebar
kitty=${dotfiles}/kitty
tmux=${dotfiles}/tmux

configure_spacebar() {
	cat ${spacebar}/base ${spacebar}/${color} >${spacebar}/spacebarrc && brew services restart spacebar
}

configure_kitty() {
	cat ${kitty}/base.conf ${kitty}/${color}.conf >${dotfiles}/kitty.conf
}

configure_tmux_light() {
	cat ${tmux}/base.conf ${tmux}/light.conf >${dotfiles}/tmux.conf
	tmux source-file ~/.tmux.conf
}

configure_tmux() {
	cat ${tmux}/base.conf >${dotfiles}/tmux.conf
	tmux source-file ~/.tmux.conf
}

configure_tmux_dark() {
	cat ${tmux}/base.conf ${tmux}/dark.conf >${dotfiles}/tmux.conf
	tmux source-file ~/.tmux.conf
}

configure_vim() {
	echo $1 >${dotfiles}/daily-driver/lua/color.lua
	echo $1 >${dotfiles}/lazy/lua/color.lua
}

case $color in
rosepinemoon)
	configure_kitty
	configure_tmux
	# configure_vim 'vim.cmd("set background=dark")'
	# configure_tmux_dark
	dark-mode on
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "rose-pine"'
	configure_spacebar
	;;
rosepinedawn)
	configure_kitty
	# configure_tmux
	# configure_vim 'vim.cmd("set background=light")'
	configure_tmux
	dark-mode off
	configure_vim 'vim.cmd("set background=light")\nvim.cmd.colorscheme "rose-pine"'
	;;
nightfoxdusk)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "duskfox"'
	dark-mode on
	configure_spacebar
	;;
nightfoxday)
	configure_kitty
	configure_tmux_light
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "dayfox"'
	dark-mode on
	configure_spacebar
	;;
nightfoxnord)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "nordfox"'
	dark-mode on
	configure_spacebar
	;;
nightfoxtera)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "terafox"'
	dark-mode on
	configure_spacebar
	;;
nightfoxdawn)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "dawnfox"'
	dark-mode off
	configure_spacebar
	;;
nightowl)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "night-owl"'
	dark-mode on
	configure_spacebar
	;;
nordic)
	configure_kitty
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "nordic"'
	dark-mode on
	configure_spacebar
	;;
ariake)
	configure_kitty
	configure_tmux
	dark-mode on
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "ariake"'
	;;
*)
	echo "Supported colorschemes: rose pine moon, rose pine dawn, nightfox-nord, nightfox-dawn, nightfox-dusk, nightfox-tera nightowl"
	exit 1
	;;
esac

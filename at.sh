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
	echo $1 >${dotfiles}/nvim/lua/color.lua
	echo $1 >${dotfiles}/nvim-minimal/lua/color.lua
}

case $color in
rosepinemoon)
	configure_kitty
	# configure_tmux
	# configure_vim 'vim.cmd("set background=dark")'
	configure_tmux_dark
	dark-mode on
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "rose-pine"'
	configure_spacebar
	;;
rosepinedawn)
	configure_kitty
	# configure_tmux
	# configure_vim 'vim.cmd("set background=light")'
	configure_tmux_light
	dark-mode off
	configure_vim 'vim.cmd("set background=light")\nvim.cmd.colorscheme "rose-pine"'
	configure_spacebar
	;;
catppuccinfrappe)
	configure_kitty
	configure_tmux
	# configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.g.catppuccin_flavour = "frappe"\nvim.cmd("colorscheme catppuccin")'
	configure_spacebar
	dark-mode on
	;;
catppuccinmocha)
	configure_kitty
	# configure_tmux_dark
	configure_tmux
	configure_vim 'vim.cmd("set background=dark")\nvim.g.catppuccin_flavour = "mocha"\nvim.cmd.colorscheme "catppuccin"'
	configure_spacebar
	dark-mode on
	;;
catppuccinlatte)
	configure_kitty
	# configure_tmux_light
	configure_tmux
	configure_vim 'vim.cmd("set background=light")\nvim.g.catppuccin_flavour = "latte"\nvim.cmd("colorscheme catppuccin")'
	configure_spacebar
	dark-mode off
	;;
tokyolight)
	# configure_alacritty
	configure_kitty
	# configure_tmux
	configure_tmux_light
	configure_vim 'vim.cmd("set background=light")\nvim.cmd.colorscheme "tokyonight"'
	configure_spacebar
	dark-mode off
	;;
tokyonight)
	# configure_alacritty
	configure_kitty
	# configure_tmux
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "tokyonight-storm"'
	configure_spacebar
	dark-mode on
	;;
nightfoxdusk)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "duskfox"'
	configure_spacebar
	dark-mode on
	;;
nightfoxday)
	configure_kitty
	configure_tmux_light
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "dayfox"'
	configure_spacebar
	dark-mode on
	;;
nightfoxnord)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "nordfox"'
	configure_spacebar
	dark-mode on
	;;
nightfoxtera)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "terafox"'
	configure_spacebar
	dark-mode on
	;;
nightfoxdawn)
	configure_kitty
	configure_tmux_light
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "dawnfox"'
	configure_spacebar
	dark-mode off
	;;
solarized)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "solarized-osaka"'
	configure_spacebar
	dark-mode off
	;;
nightowl)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "night-owl"'
	configure_spacebar
	dark-mode on
	;;
monet)
	configure_kitty
	configure_tmux_dark
	configure_vim 'vim.cmd("set background=dark")\nvim.cmd.colorscheme "monet"'
	configure_spacebar
	dark-mode on
	;;
*)
	echo "Supported colorschemes: tokyolight, tokyonight, rose pine moon, rose pine dawn, nightfox-nord, nightfox-dawn, nightfox-dusk, nightfox-tera"
	exit 1
	;;
esac

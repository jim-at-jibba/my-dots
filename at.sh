#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
spacebar=${dotfiles}/spacebar
sketchybar=${dotfiles}/sketchybar
kitty=${dotfiles}/kitty
tmux=${dotfiles}/tmux

configure_spacebar() {
  cat ${spacebar}/base ${spacebar}/${color} >${spacebar}/spacebarrc && brew services restart spacebar
}

configure_sketchybar() {
  cat ${sketchybar}/colors/${color}.sh >${sketchybar}/colors.sh && sketchybar --reload
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

configure_lazy() {
  echo $1 >${dotfiles}/lazy/lua/plugins/theme.lua
}

case $color in
rosepinemoon)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine"}}}'
  configure_sketchybar
  # configure_spacebar
  ;;
rosepinedawn)
  configure_kitty
  # configure_tmux
  # configure_vim 'vim.cmd("set background=light")'
  configure_tmux
  dark-mode off
  configure_sketchybar
  # configure_spacebar
  configure_lazy 'vim.cmd("set background=light")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine"}}}'
  ;;
poimandres)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "poimandres"}}}'
  configure_sketchybar
  ;;
nightfoxdusk)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "duskfox"}}}'
  dark-mode on
  configure_sketchybar
  # configure_spacebar
  ;;
nightfoxday)
  configure_kitty
  configure_tmux_light
  configure_lazy 'vim.cmd("set background=light")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "dayfox"}}}'
  dark-mode off
  # configure_spacebar
  ;;
nightfoxnord)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "nordfox"}}}'
  dark-mode on
  # configure_spacebar
  ;;
nightfoxtera)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "terafox"}}}'
  dark-mode on
  configure_sketchybar
  # configure_spacebar
  ;;
nightfoxdawn)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=light")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "dawnfox"}}}'
  dark-mode off
  # configure_spacebar
  ;;
nightowl)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "night-owl"}}}'
  dark-mode on
  configure_sketchybar
  # configure_spacebar
  ;;
nordic)
  configure_kitty
  configure_tmux
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "nordic"}}}'
  dark-mode on
  # configure_spacebar
  ;;
ariake)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "ariake"}}}'
  configure_sketchybar
  # configure_spacebar
  ;;
solarizeddark)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "NeoSolarized"}}}'
  configure_spacebar
  ;;
solarizedlight)
  configure_kitty
  configure_tmux
  dark-mode off
  configure_lazy 'vim.cmd("set background=light")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "NeoSolarized"}}}'
  configure_spacebar
  ;;
tokyonight)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight"}}}'
  configure_spacebar
  ;;
cyberdreamdark)
  configure_kitty
  configure_tmux
  dark-mode on
  configure_lazy 'vim.cmd("set background=dark")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "cyberdream"}}}'
  configure_spacebar
  ;;
cyberdreamlight)
  configure_kitty
  configure_tmux
  dark-mode off
  configure_lazy 'vim.cmd("set background=light")\nreturn { { "LazyVim/LazyVim", opts = { colorscheme = "cyberdream"}}}'
  configure_spacebar
  ;;
*)
  echo "Supported colorschemes: rose pine moon, rose pine dawn, nightfox-nord, nightfox-dawn, nightfox-dusk, nightfox-tera nightowl oldworld"
  exit 1
  ;;
esac

#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
alacritty=${dotfiles}/alacritty
kitty=${dotfiles}/kitty
tmux=${dotfiles}/tmux

configure_alacritty() {
  cat ${alacritty}/base.yml ${alacritty}/${color}.yml > ${dotfiles}/alacritty.yml
}

configure_kitty() {
  cat ${kitty}/base.conf ${kitty}/${color}.conf > ${dotfiles}/kitty.conf
}

configure_tmux() {
  cat ${tmux}/base.conf ${tmux}/${color}.conf > ${dotfiles}/tmux.conf
  tmux source-file ~/.tmux.conf.local
}

configure_vim() {
  echo $1 > ${dotfiles}/nvim/lua/color.lua
}

case $color in
  rosepinemoon)
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=dark")'
    dark-mode on
    # configure_vim 'vim.cmd("set background=dark")\nvim.cmd("colorscheme rose-pine")'
    ;;
  rosepinedawn)
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=light")'
    dark-mode off
    # configure_vim 'vim.cmd("set background=light")\nvim.cmd("colorscheme rose-pine")'
    ;;
  catppuccinfrappe)
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=dark")\nvim.g.catppuccin_flavour = "frappe"\nvim.cmd("colorscheme catppuccin")'
    dark-mode on
    ;;
  catppuccinlatte)
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=light")\nvim.g.catppuccin_flavour = "latte"\nvim.cmd("colorscheme catppuccin")'
    dark-mode off
    ;;
  tokyolight)
    configure_alacritty
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=light")\nvim.cmd("colorscheme tokyonight")'
    dark-mode off
    ;;
  tokyonight)
    configure_alacritty
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=dark")\nvim.cmd("colorscheme tokyonight")'
    dark-mode on
    ;;
  nightfoxnord)
    configure_kitty
    configure_tmux
    configure_vim 'vim.cmd("set background=dark")\nvim.cmd("colorscheme nordfox")'
    dark-mode on
    ;;
  nightfoxday)
    configure_kitty
    configure_vim 'vim.cmd("set background=light")\nvim.cmd("colorscheme dayfox")'
    dark-mode off
    ;;
  nightfoxdawn)
    configure_kitty
    configure_vim 'vim.cmd("set background=light")\nvim.cmd("colorscheme dawnfox")'
    dark-mode on
    ;;
  *)
    echo "Supported colorschemes: tokyolight, tokyonight, rose pine moon, rose pine dawn, nightfox nord, nightfox day"
    exit 1
    ;;
esac

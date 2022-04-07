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
  echo $1 > ${dotfiles}/nvim/color.vim
}

case $color in
  rosepine)
    configure_kitty
    configure_vim 'let g:rose_pine_enable_italics = 1\nlet g:rose_pine_variant = "base"\nlet g:rose_pine_disable_background = 1\ncolorscheme rose-pine'
    ;;
  # rosepinemoon)
  #   configure_kitty
  #   configure_vim 'let g:rose_pine_enable_italics = 1\nlet g:rose_pine_variant = "moon"\nlet g:rose_pine_disable_background = 1\ncolorscheme rose-pine'
  #   ;;
  rosepinemoon)
    configure_kitty
    configure_vim 'colorscheme rose-pine\nset background=dark'
    ;;
  rosepinedawn)
    configure_kitty
    configure_vim 'colorscheme rose-pine\nset background=light'
    ;;
  tokyolight)
    configure_alacritty
    configure_kitty
    configure_tmux
    configure_vim 'set background=light\nlet g:tokyonight_style = "day"\ncolorscheme tokyonight'
    ;;
  tokyonight)
    configure_alacritty
    configure_kitty
    configure_tmux
    configure_vim 'set background=dark\nlet g:tokyonight_style = "storm"\ncolorscheme tokyonight'
    ;;
  nightfoxnord)
    configure_kitty
    configure_vim 'set background=dark\ncolorscheme nordfox'
    ;;
  *)
    echo "Supported colorschemes: Oceanic Next, Nord, Ariake, embark, tokyolightm tokyonight"
    exit 1
    ;;
esac

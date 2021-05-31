#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
alacritty=${dotfiles}/alacritty

configure_alacritty() {
  cat ${alacritty}/base.yml ${alacritty}/${color}.yml > ${dotfiles}/alacritty.yml
}

configure_vim() {
  echo $1 > ${dotfiles}/nvim/color.vim
}

case $color in
  oceanicnext)
    configure_alacritty
    configure_vim 'colorscheme oceanicnext\nlet g:oceanic_next_terminal_bold = 1\nlet g:oceanic_next_terminal_italic = 1'
    ;;
  nord)
    configure_alacritty
    configure_vim 'colorscheme nord'
    ;;
  ariakelight)
    configure_alacritty
    configure_vim 'set background=light\ncolorscheme ariake'
    ;;
  ariakedark)
    configure_alacritty
    configure_vim 'set background=dark\ncolorscheme ariake'
    ;;
  embark)
    configure_alacritty
    configure_vim 'set background=dark\ncolorscheme embark'
    ;;
  tokyolight)
    configure_alacritty
    configure_vim 'set background=light\nlet g:tokyonight_style = "day"\ncolorscheme tokyonight'
    ;;
  tokyonight)
    configure_alacritty
    configure_vim 'set background=dark\nlet g:tokyonight_style = "storm"\ncolorscheme tokyonight'
    ;;
  *)
    echo "Supported colorschemes: Oceanic Next, Nord, Ariake, embark, tokyolightm tokyonight"
    exit 1
    ;;
esac

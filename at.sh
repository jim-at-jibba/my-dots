#!/bin/sh
# https://shuheikagawa.com/blog/2020/02/14/switching-colorschemes-of-vim-and-alacritty/

color=$1
dotfiles=~/dotfiles
alacritty=${dotfiles}/alacritty
kitty=${dotfiles}/kitty

configure_alacritty() {
  cat ${alacritty}/base.yml ${alacritty}/${color}.yml > ${dotfiles}/alacritty.yml
}

configure_kitty() {
  cat ${kitty}/base.conf ${kitty}/${color}.conf > ${dotfiles}/kitty.conf
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
    configure_kitty
    configure_vim 'set background=dark\nlet g:nord_disable_background = v:true\nlet g:nord_italic = v:true\nlet g:nord_contrast = v:true\nlet g:nord_borders = v:true\ncolorscheme nord'
    ;;
  ariakelight)
    configure_alacritty
    configure_vim 'set background=light\ncolorscheme ariake'
    ;;
  ariakedark)
    configure_alacritty
    configure_kitty
    configure_vim 'set background=dark\ncolorscheme ariake'
    ;;
  everforestdarkmedium)
    configure_kitty
    configure_vim 'set background=dark\ncolorscheme everforest'
    ;;
  everforestlightmedium)
    configure_kitty
    configure_vim 'set background=light\ncolorscheme everforest'
    ;;
  rosepine)
    configure_kitty
    configure_vim 'let g:rose_pine_enable_italics = 1\nlet g:rose_pine_variant = "base"\nlet g:rose_pine_disable_background = 1\ncolorscheme rose-pine'
    ;;
  rosepinemoon)
    configure_kitty
    configure_vim 'let g:rose_pine_enable_italics = 1\nlet g:rose_pine_variant = "moon"\nlet g:rose_pine_disable_background = 1\ncolorscheme rose-pine'
    ;;
  rosepinedawn)
    configure_kitty
    configure_vim 'let g:rose_pine_enable_italics = 1\nlet g:rose_pine_variant = "dawn"\nlet g:rose_pine_disable_background = 1\ncolorscheme rose-pine'
    ;;
  embark)
    configure_alacritty
    configure_kitty
    configure_vim 'set background=dark\ncolorscheme embark'
    ;;
  tokyolight)
    configure_alacritty
    configure_kitty
    configure_vim 'set background=light\nlet g:tokyonight_style = "day"\ncolorscheme tokyonight'
    ;;
  tokyonight)
    configure_alacritty
    configure_kitty
    configure_vim 'set background=dark\nlet g:tokyonight_style = "storm"\ncolorscheme tokyonight'
    ;;
  kanagawa)
    configure_kitty
    configure_vim 'set background=dark\ncolorscheme kanagawa'
    ;;
  *)
    echo "Supported colorschemes: Oceanic Next, Nord, Ariake, embark, tokyolightm tokyonight"
    exit 1
    ;;
esac

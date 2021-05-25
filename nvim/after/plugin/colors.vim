if (has("termguicolors"))
  set termguicolors
endif

lua require'colorizer'.setup()

if !exists('g:syntax_on')
  syntax enable
endif

" Should this be in ~/.config
let color_path = expand('~/dotfiles/nvim/color.vim')

if filereadable(color_path)
  exec 'source' color_path
else
  set background=dark
  colorscheme ariake
endif


set t_Co=256

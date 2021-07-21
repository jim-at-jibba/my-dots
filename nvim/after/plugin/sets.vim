  set exrc " allows for local vimrc in projects
  set tabstop=2 softtabstop=2
  set shiftwidth=2
  set expandtab
  set smartindent
  set nohlsearch
  set nopaste
  set number
  set hidden
  set noerrorbells
  set nospell
  set splitbelow
  set splitright
  set relativenumber
  set nu
  set scrolloff=8
  set completeopt=menu,menuone,noinsert,noselect
  set signcolumn=yes
  set updatetime=100
  set timeoutlen=500
  set incsearch
  set noshowmode

  " Fold stuff
  set nofoldenable
  set foldlevel=99
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()

  set nobackup
  set nowritebackup
  set noswapfile


  if has("persistent_undo")
      set undodir="~/.vim/.undodir"
      set undofile
  endif

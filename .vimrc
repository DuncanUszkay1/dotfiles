" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'elixir-editors/vim-elixir'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'flazz/vim-colorschemes'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-ruby/vim-ruby'
call vundle#end()
filetype plugin indent on

syntax on " syntax highlighting
set tabstop=2 shiftwidth=2 expandtab " two space tabs
set linebreak wrap " visual text wrapping
set autoindent smartindent " so-called 'smart' indentation
set noerrorbells visualbell t_vb= " disable error bell garbage
set backspace=indent,eol,start " make backspace work
set foldmethod=indent

" gitgutter
set updatetime=100
map hu <Leader>hu

" ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --path-to-ignore ~/.ignore'
let g:ctrlp_use_caching = 0

" NerdTree
let g:NERDTreeNodeDelimiter = "\u00a0"
map <C-n> :NERDTreeToggle<CR>
map <C-m> :NERDTreeToggle %<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" avoiding the shift key in commands as much as possible
" normal mode map ; to :
nnoremap ; :
" visual mode map ; to :
vnoremap ; :

cnoreabbrev <expr> s ((getcmdtype() is# ':%' && getcmdline() is# 's')?('S'):('s'))

" Text navigation
map w 10k
map s 10j
map x :StripWhitespace <Enter>

command Key s/console.log(\(.*\))/console.log(Object.keys(\1))
command NoKey s/console.log(Object.keys(\(.*\)))/console.log(\1)
command Nprint s/\( *\)\(.*\)/\1console.log(\"\2 \" + \2)

" colors
colorscheme brogrammer
" fyi need to get rid of the Default suffix on the gitgutter customization

" tab max
set tabpagemax=2

" who gives a fuck about this but here ya go
:set nofixendofline

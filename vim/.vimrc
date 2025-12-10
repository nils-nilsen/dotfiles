set nocompatible
filetype plugin indent on
set ignorecase
set smartcase
set hlsearch
set number! relativenumber!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'fatih/vim-go'

call vundle#end()
filetype plugin indent on

"#NERDtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let mapleader = ","
nmap <leader>ne :NERDTree<cr>
map <C-n> :NERDTreeToggle<CR>

"#syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"#theme
syntax enable
set background=dark
"colorscheme solarized

set backspace=indent,eol,start

" fzf
set rtp+=/usr/local/opt/fzf

nnoremap <C-L> :nohl<CR><C-L>
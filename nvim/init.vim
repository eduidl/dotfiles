if &compatible
  set nocompatible
endif

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim ' s:dein_repo_dir
endif
execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml_dir = expand('~/.config/nvim/dein/toml')
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
end

if dein#check_install(['vimproc.vim'])
  call dein#install(['vimproc.vim'])
endif

if dein#check_install()
  call dein#install()
endif

set hidden
set noswapfile
set termguicolors
set fenc=utf-8
set number
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set wrapscan
set clipboard=unnamed
set inccommand=split
set list
set listchars=tab:»-,trail:-,nbsp:%,eol:↲
colorscheme desert
filetype plugin indent on
syntax enable

autocmd BufRead,BufNewFile *.fish setfiletype fish
autocmd FileType fish setlocal sw=4 sts=4 ts=4 et

augroup NERDTreeGroup
  autocmd!
  autocmd vimenter * NERDTree | call feedkeys("\<C-w>") | call feedkeys("\w")
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

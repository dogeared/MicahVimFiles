set nocompatible
filetype plugin indent on
syntax on

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'bufexplorer.zip'
Bundle 'bufmru.vim'
Bundle 'https://github.com/wincent/Command-T.git'
Bundle 'https://github.com/pangloss/vim-javascript.git'
Bundle 'https://github.com/vim-scripts/surround.vim.git'

" Autoclose parens etc.
" Bundle 'https://github.com/Townk/vim-autoclose.git'
" Text alignment
Bundle 'https://github.com/godlygeek/tabular.git'
" Code snipets
Bundle 'https://github.com/malkomalko/snipmate.vim.git'
" Fast code commenting
Bundle 'https://github.com/scrooloose/nerdcommenter.git'
" Project folder
Bundle 'https://github.com/scrooloose/nerdtree.git'
" Cucumber
Bundle 'https://github.com/tpope/vim-cucumber.git'
" Stylus
Bundle 'https://github.com/wavded/vim-stylus.git'

set ar
set expandtab
set hid
set hlsearch
set incsearch
set nobackup
set noswapfile
set nu
set shiftwidth=2
set tabstop=2
set wildignore+=.git,.svn,**/node_modules/*,DS_Store,*.log,*.sock
set wildignore+=*.png,*.gif,*.jpg,*.jpeg,*.class,nohup.out,*.swp
set wildignore+=*.tmproj,*.pid,**/tmp/*
set wildmenu
set wildmode=list:longest,full
set wrap

" functions

" Align Fit Tables
function! s:alignFitTables()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
command! -nargs=0 AlignFitTables call s:alignFitTables()

function! s:SetTestFile()
  let g:CurrentTestFile = expand("%")
  let g:CurrentTestExt  = expand("%:e")
endfunction
command! -nargs=0 SetTestFile call s:SetTestFile()

function! s:RunTestFile()
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo

  if !exists("g:CurrentTestFile")
    let g:CurrentTestFile = expand("%")
    let g:CurrentTestExt  = expand("%:e")
  endif

  if g:CurrentTestExt == "js"
    execute "w\|!TEST=true NODE_ENV=test ./node_modules/.bin/mocha --reporter dot 
      \ " . g:CurrentTestFile 
  elseif g:CurrentTestExt == "clj"
    execute "w\|!echo \"I can't do this yet\""
  endif
endfunction
command! -nargs=0 RunTestFile call s:RunTestFile()

let mapleader = ","
let maplocalleader = ","

cnoremap %% <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev <C-w><C-v><C-l>:e ~/.vimrc<cr>
map <Leader>ga :CommandTFlush<CR>\|:CommandT<CR>
map <Leader>gf :CommandTFlush<CR>\|:CommandT %%<CR>
map <Leader>gl :CommandTFlush<CR>\|:CommandT lib<CR>
map <Leader>h :set invhls<CR>
noremap <Leader>i :set list!<CR>
imap jj <c-c>
nmap k gk
nmap j gj
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
map <Leader>r :RunTestFile<CR>
map <Leader>sv :so ~/.vimrc<CR>
map <Leader>; :SetTestFile<CR>
noremap <Leader>at :AlignFitTables<CR>
noremap <Leader>n :NERDTreeToggle<CR>

" bufexplorer
let g:bufExplorerDefaultHelp=1
let g:bufExplorerShowDirectories=0
let g:bufExplorerShowRelativePath=1

" command-t
let g:CommandTMaxFiles=10000

" clojure
let g:vimclojure#HighlightBuiltins=1
au BufRead,BufNewFile *.clj set filetype=clojure

" Gui Setup *******************************************************************
if has("gui_running")
  if has("gui_gnome")
    set term=gnome-256color
    set guifont=Inconsolata\ 16
    set guioptions-=T
    set guioptions-=m
    set guioptions+=c
    set guioptions-=rL
    set lines=100
    set columns=185
  else
    set guitablabel=%M%t
    set lines=100
    set columns=185
  endif

  if has("gui_mac") || has("gui_macvim")
    set guifont=Inconsolata:h22
    set fuoptions=maxvert,maxhorz
    set guioptions-=T
    set guioptions-=m
    set guioptions+=c
    set guioptions-=rL
    " set colorcolumn=81
    colorscheme jellybeans 
  endif
endif


" NERDTree ********************************************************************

" User instead of Netrw when doing an edit /foobar
let NERDTreeHijackNetrw=1

" Single click for everything
let NERDTreeMouseMode=1

" Ignore
let NERDTreeIgnore=['\.git','\.DS_Store','\.pdf','\.png','\.jpg','\.gif']

" Quit on open
let NERDTreeQuitOnOpen=1

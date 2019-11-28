set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/

call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim' 

Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'davidhalter/jedi-vim'
Plugin 'andviro/flake8-vim'

call vundle#end()

" Make tab the default for omni-complete, and make it context aware
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

" Map the leader key to ,
let mapleader = ","

filetype plugin indent on

" tell vim to look for a tags file anywhere in the project dir
set tags=./tags;/

" turn syntax highlighting on by default
syntax on

" set auto-indenting on for programming
set ai

" Make mouse middle click paste without formatting it.
map <MouseMiddle> <Esc>"*p

" Better modes.  Remeber where we are, support yankring
set viminfo=!,'100,\"100,:20,<50,s10,h,n~/.viminfo

" Move Backup Files to ~/.vim/sessions
set backupdir=~/.vim/sessions
set dir=~/.vim/sessions

" Turn off annoying swapfiles
set noswapfile

" highlight search terms incrementally
set incsearch

" automatically show matching brackets. works like it does in bbedit.
set showmatch

" do NOT put a carriage return at the end of the last line! if you are programming
" for the web the default will cause http headers to be sent. that's bad.
set binary noeol

" make that backspace key work the way it should
set backspace=indent,eol,start

" turn-off toolbar
set guioptions-=T

" turn-off scrollbar
set guioptions-=L
set guioptions-=r

" add line numbers
set nu

" don't wrap lines
set nowrap

" login to shell
set shell=bash\ --login

" allow tab completion of buffers
set wildchar=<Tab> wildmenu wildmode=full

" map [jj] to Esc and Write in insert mode
inoremap jj <Esc>:w<CR> :redraw!<CR>
inoremap ;; <End>;<Esc>:w<CR>

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Show the full path of the current file
noremap ff :echo expand('%:p')<CR>

" Show the full path of the current file and add it to a yank register
noremap cp :let @" = expand("%:p")<CR>

" Make window movement easier
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Remove all trailing whitespace from file and save
noremap <C-S> :%s/\s\+$//g<CR>:w<CR>

" Swap ; and :  Convenient.
nnoremap ; :
nnoremap : ;

" show all open buffers
noremap _ :ls<CR>:b

" noremap dos :e ++ff=dos<CR>:w<CR>

" set line number color
highlight LineNr guifg=#666666
highlight ColorColumn ctermbg=darkgrey guibg=#2f2f2f
set colorcolumn=79
set ruler

" highlight things that we find with the search
set hlsearch

"{{{Taglist configuration
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Highlight_Tag_On_BufEnter = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Show_One_File = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Ctags_Cmd = "vimctags"
"}}}

" tell NERDTree to ignore .pyc files
let NERDTreeIgnore = ['\.pyc$', '\.class$']

autocmd FileType html,htmldjango,jinjahtml,eruby,mako,twig let b:closetag_html_style=1

" abbreviations
ab ip import ipdb; ipdb.set_trace()
let g:dwm_map_keys=0

" Turn off error bells and visual bells
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Remove all whitespace from the end of files
autocmd BufWritePre *.py :%s/\s\+$//e

" Go to previous (last accessed) window.
autocmd VimEnter * wincmd p

syntax enable
colorscheme xoria256


" Make jedi behave better
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0

" Yank text to the OS X clipboard
noremap <Leader>y "*y
noremap <Leader>yy "*Y

" Preserve indentation while pasting text from the OS X clipboard
noremap <Leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

" Save and close a file with ,,
nnoremap ,, <ESC>ZZ
inoremap ,, <ESC>ZZ

set undofile
set undodir=~/.vim_undo
set undolevels=5000 

nnoremap <leader>1 yypVr=
nnoremap <leader>q gqip

nnoremap <C-RIGHT> <C-w>>
nnoremap <C-LEFT> <C-w><
nnoremap <C-UP> :1winc -<CR>
nnoremap <C-DOWN> :1winc +<CR>

nnoremap <Space> <Tab>
nnoremap <S-space> <C-o>

" Map <Ctrl-c> to auto complete for java files using Eclim
inoremap <C-c> <C-x><C-u>

" Remap :JavaCorrect to <C-g>
nnoremap <C-g> :JavaCorrect <CR>

"
" set our tabs to four spaces
set smartindent
set expandtab
set sw=4
set ts=4

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set clipboard=unnamed

" Use real tabs for .go files
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

" Map ,d to jump to definition for go files
au FileType go nmap <leader>d <Plug>(go-def)

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <leader>i <Plug>(go-install)
au FileType go nmap <leader>gd <Plug>(go-doc)
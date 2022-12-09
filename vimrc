" XDG support

if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME  = $HOME."/.cache"       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME = $HOME."/.config"      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME   = $HOME."/.local/share" | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME  = $HOME."/.local/state" | endif

set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

let g:netrw_home = $XDG_DATA_HOME."/vim"
call mkdir($XDG_DATA_HOME."/vim/spell", 'p', 0700)

set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p', 0700)
set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p', 0700)
set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p', 0700)
set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p', 0700)

if !has('nvim') " Neovim has its own special location
  set viminfofile=$XDG_STATE_HOME/vim/viminfo
endif

""" This is ninoCan's .vimrc file """
set nocompatible           " Do not behave like vi

filetype plugin indent on  " Load plugins according to detected filetype
syntax enable              " Enable syntax highlighting

" Numberline {{{
set number                 " Display line number
set relativenumber         " Display relative numbers
"}}}

"The following commands set <TAB> width to 4 spaces {{{
set autoindent             " Indent according to previous line
set expandtab              " Use spaces instead of tabs
set tabstop     =4         " Actual width of tab character
set softtabstop =4         " Tab key indents by 4 spaces
set shiftwidth  =4         " >> indents by 4 spaces
set shiftround             " >> indents to next multiple of 'shiftwidth'
set mouse       =v         " Enable the mouse actions in all modes
" }}}

" {{{
set backspace   =indent,eol,start  " Make backspace work as you would expect
set hidden                 " Switch between buffers without having to save first
set laststatus  =2         " Always show statusline
"}}}

" Visual rending of overflowing lines {{{
set wrap
set linebreak              " Wrap long lines
set showbreak=⏎⏎\ \        " How to render the continued line
set display     =lastline  " Show as much as possible of the last line
set columns     =75        " visually wrap text at 80 character 
set formatoptions+=wjp     " Wrap lines at whitespaces do not wrap after period
set breakindent            " Respect indentation when folding
set showmode               " Show current mode in command-line
set showcmd                " Show already typed keys when more are expected
" }}}

" Search options {{{
set incsearch              " Highlight while searching with / or ?
set hlsearch               " Keep matches highlighted
set ignorecase             "Ignore case when searching
"}}}


" {{{
set splitbelow             " Open new windows below the current window
set splitright             " Open new windows right of the current window
" }}}

" {{{
set cursorline             " Find the current line quickly
set wrapscan               " Searches wrap around end-of-file
set report      =0         " Always report changed lines
set synmaxcol   =200       " Only highlight the first 200 columns
" }}}

" {{{
set list                   " Show non-printable characters
if has('multi_byte') && &encoding ==# 'utf-8'
    let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
    let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif
" }}}


" {{{
" Put all temporary files under the same directory
" https://github.com/mhinz/vim-galore#temporary-files
"set backup
"set backupdir   =$HOME/.vim/files/backup/
"set backupext   =-vimbackup
"set backupskip  =
"set directory   =$HOME/.vim/files/swap//
"set updatecount =100
"set undofile
"set undodir     =$HOME/.vim/files/undo/
"set viminfo     ='100,n$HOME/.vim/files/info/viminfo
set noswapfile           "Deactivate swapfile
" }}}

""""""""" AUTO COMMANDS
" highlight unnecessary whitespace {{{
augroup highlight_whitespace:
    autocmd!
    highlight BadWhitespace ctermbg=red guibg=darkred
    autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
augroup END
" }}}

" Spell checking activated globally {{{
augroup check_spelling:
    autocmd!
    autocmd BufNewFile,BufRead *.md,*.txt,*rc :set spell spelllang=en_us
augroup END
" }}}

" Vimscript file settings {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


""""""""" VIM PLUG

" Automatic installation: install vim-plug if not found {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : g:netrw_home
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" Run PlugInstall if there are missing plugins {{{
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
\| PlugInstall --sync | source $MYVIMRC
\| endif
" }}}

" Start the plugin manager and register plugins {{{
call plug#begin(g:netrw_home.'/bundle')

    " Register vim-plug itself for :help support
    Plug 'junegunn/vim-plug'

    " comment line(s) with gcc/gc<motion>
    Plug 'tpope/vim-commentary'

    " git commands in vim and diff in files
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Python-specific text objects and motions
    Plug 'jeetsukumaran/vim-pythonsense'

    " broot launches vim
    Plug 'lstwn/broot'

    " folding for Python
    "Plug 'tmhedberg/SimpylFold'

    " fzf
    Plug 'junegunn/fzf.vim'

    " display and search LSP symbols and thumbnails
    Plug 'liuchengxu/vista.vim'

    " auto-indenting
    Plug 'vimjas/vim-python-pep8-indent'

    " Asynchronous Linting Engine & vim-lsp
    Plug 'dense-analysis/ale'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'rhysd/vim-lsp-ale'

    " lean & mean status/tabline
    Plug 'vim-airline/vim-airline'

    " vscode-dark theme
    Plug 'tomasiser/vim-code-dark'

    " nightfly-colors theme
    Plug 'bluz71/vim-nightfly-colors'
    
    " nightfox theme
    Plug 'EdenEast/nightfox.nvim'

    " search and autocomplete unicode characters
    Plug 'chrisbra/unicode.vim'

call plug#end()
"}}}


""""""""" PYTHON SUPPORT

"python virtualenv support {{{
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(
        compile(
            open(activate_this, "rb").read(),
            activate_this, 'exec'),
            dict(__file__=activate_this)
    )
EOF
" }}}


"""""""""""""""""" LEADER KEYBINDINGS
"  {{{
let mapleader = " "             " map leader to Space
noremap <leader>ev :vsplit $MYVIMRC<CR>
noremap <leader>j :bn<CR>
noremap <leader>k :bp<CR>
noremap <leader>s :source %<CR>
noremap <leader>w <C-W>w
noremap <leader>; mqA;<ESC>`q
let maplocalleader = "//"       " Set localleader to //
" Ctrl-u capitalize current words
inoremap <c-u> <esc>viwUi
nnoremap <c-u> viwU
" Swap colon and semicolon for faster command execution
noremap : ;
noremap ; :
" Toggle off highlight of previous search
nnoremap <silent> <leader><esc> :noh<cr><esc>
" }}}


"""""""""""""""""" AIRLINE
" {{{
set ttyfast                " Faster redrawing
set t_Co=256                " Set colors to 256
set t_ut=
" THEMES
" colorscheme nightfox       " Set the color theme to match vscode
let g:airline_theme = 'nightfly'
set enc=utf-8
set guifont=Powerline_Consolas:h11
set renderoptions=type:directx,gamma:1.5,contrast:0.5,geom:1,renmode:5,taamode:1,level:0.5
" }}}


"""""""""""""""""" ABBREVIATIONS
"{{{
iabbrev @@ ninocangialosi@yahoo.it
iabbrev myssign Antonino Cangialosi
"}}}

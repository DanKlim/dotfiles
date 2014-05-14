" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" utf-8 encoding.
scriptencoding utf-8
set encoding=utf-8

" Prevent a mem/cpu bug.
" http://lists.alioth.debian.org/pipermail/pkg-vim-maintainers/2007-June/004020.html
set modelines=0

" Change map leader for ease.
let mapleader=','
let maplocalleader='['

" Remappings ------------------------ {{{
" Remap some keys for faster usage.
nnoremap ; :
vnoremap ; :

" Move up and down by screen line, not file line.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Help files settings --------------- {{{
augroup center
  autocmd!
  " Center line except for help files.
  autocmd BufEnter * let &scrolloff = &filetype == 'help' ? 0 : 99
  autocmd FileType help nnoremap <buffer> j j<c-e>
  autocmd FileType help nnoremap <buffer> k <c-y>k
augroup END
" }}}

" Don't activate these when clicked accidentally.
nnoremap Q <nop>
nnoremap K <nop>

" Move through buffers with Cmd + j/k.
nnoremap <d-j> :bn<cr>
nnoremap <d-k> :bp<cr>

" Move to the last buffer with Cmd + i.
nnoremap <d-i> <c-^>

" Redo to U.
nnoremap U <c-r>

" Navigate windows with Shift + hjkl.
nnoremap H <c-w>h
nnoremap J <c-w>j
nnoremap K <c-w>k
nnoremap L <c-w>l

" Uppercase word.
inoremap <c-u> <esc>viwUe
nnoremap <c-u> viwU

" Add a closing bracket and new line when typing an opening bracket.
augroup filetype_js
  autocmd!
  autocmd FileType javascript inoremap <buffer>
   \ {<cr> <esc>:call <SID>CloseBracket('{', '}')<cr>O
  autocmd FileType javascript inoremap <buffer>
   \ [<cr> <esc>:call <SID>CloseBracket('[', ']')<cr>O
augroup END

function! s:CloseBracket(open, close)
  let cline = getline('.')
  if cline =~# '\S = ' && cline !~# '^\s*for\s\?('
    let sc = ';'
  else
    let sc = ''
  endif
  execute "normal! a" . a:open . "\<cr>" . a:close . sc
endfunction

" <up> to show the last command used.
" Rather than pressing ; followed by <up>.
nnoremap <up> :<up>

" Split Windows.
nnoremap <leader>v <c-w>s<C-w>j
nnoremap <leader>V :vs<cr>

" }}}

" Searching ------------------------- {{{
" Search for word over cursor puts cursor at first keyword.
nnoremap * *N
vnoremap * *N

" Clears the search. (c)
nnoremap <leader><space> :nohlsearch<cr>
" Ignore case of searches.
set ignorecase

" If the search contains an upper-case character, become case sensitive.
set smartcase

" Start searching without pressing enter.
set incsearch

" Highlight all search matches.
set hlsearch

" Search for word under cursor and display results in window.
"nnoremap <leader>g
  "\ :silent execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>
  "\ :copen<cr>

" Mappings for :cnext and :cprevious
nnoremap <leader>e :cprevious<cr>
nnoremap <leader>r :cnext<cr>
" }}}

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Indent a new line the same way as the previous.
set autoindent

" Jump to brace/paranthese/brackets.
set showmatch

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Set tab width to 2 for all files and replace tabs with spaces.
set tabstop=2
set shiftwidth=2
set expandtab
augroup filetype_go
  autocmd!
  autocmd FileType go setlocal noexpandtab
augroup END

" Highlight cursor.
highlight CursorLine ctermbg=8 cterm=NONE

" Set cwd to opened file so that opening other files is easier.
set autochdir

" Make cycling through files same as in bash.
set wildmenu
set wildmode=longest,list

" Autoread files on changes.
set autoread

" Folding ------------------ {{{
set foldmethod=indent
set foldnestmax=5
set foldlevelstart=4

" Use space to toggle folds.
nnoremap <silent> <space> za
vnoremap <space> zf

" Vimscript file settings ------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd BufRead *.vim setlocal foldmethod=marker
augroup END
" }}}
" }}}

" Faster communication with vim.
set ttyfast

" Allow edited buffers to be hidden.
set hidden

" Tab settings --------------------- {{{
" Keep modes local to tabs.
" I often switch tabs, in modes that are not "normal", using keyboard
" shortcuts available to MacVim: Ctrl + {/}.
" Normally vim changes to normal mode when switching tabs.
" This keeps the last mode that was used in a tab.
"
" http://stackoverflow.com/questions/22389934/how-can-i-keep-modes-local-to-a-tab
augroup TAB_MODES
  autocmd!
  autocmd TabLeave * let t:lastmode = mode(1)
  autocmd TabEnter * if !exists('t:lastmode') | let t:lastmode = 'n' | endif
  autocmd TabEnter * if t:lastmode ==# 'n'  | stopinsert    | endif
  autocmd TabEnter * if t:lastmode ==# 'i'  | startinsert   | endif
  autocmd TabEnter * if t:lastmode ==# 'R'  | startreplace  | endif
  autocmd TabEnter * if t:lastmode ==# 'Rv' | startgreplace | endif
augroup END

" Only show tab bar if there is more than 1.
set showtabline=1
" }}}

" Status line ------------------------ {{{
" Show line and column number in status bar.
set ruler

" Show keys in status bar as they are typed.
set showcmd
" }}}

" Don't use the mouse.
set mouse=r

nnoremap <leader>q :call <SID>QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! s:QuickfixToggle()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open = 0
    execute g:quickfix_return_to_window . "wincmd w"
  else
    let g:quickfix_return_to_window = winnr()
    copen
    let g:quickfix_is_open = 1
  endif
endfunction

" Split windows below by default.
set splitbelow

augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre *
    \ if expand("<afile>")!~#'^\w\+:/' &&
    \ !isdirectory(expand("%:h")) |
    \ execute "silent! !mkdir -p ".shellescape(expand('%:h'), 1) |
    \ redraw! | endif
augroup END

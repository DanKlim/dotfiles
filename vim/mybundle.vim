" Let Vundle manage Vundle.
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Usage -------------------- {{{
Bundle 'scrooloose/syntastic'
Bundle 'danro/rename.vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
"Bundle 'twe4ked/vim-peepopen'
"Bundle 'airblade/vim-rooter'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'tpope/vim-fugitive'
" }}}

" Mappings ----------------- {{{
Bundle 'scrooloose/nerdcommenter'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'godlygeek/tabular'
Bundle 'tomtom/tlib_vim'
"Bundle 'garbas/vim-snipmate'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'dahu/vim-fanfingtastic'
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'marijnh/tern_for_vim'
"Bundle 'vim-scripts/YankRing.vim'
"Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-endwise'
" }}}

" Environemnts ------------- {{{
Bundle 'moll/vim-node'
Bundle 'fatih/vim-go'
" }}}

" Syntax Highlighting ------ {{{
Bundle 'plasticboy/vim-markdown'
Bundle 'pangloss/vim-javascript'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'elzr/vim-json'
Bundle 'lukaszb/vim-web-indent'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/applescript.vim'
Bundle 'vim-scripts/AnsiEsc.vim'
Bundle 'othree/xml.vim'
Bundle 'leafgarland/typescript-vim'
" }}}

" Color schemes ------------ {{{
Bundle 'goatslacker/mango.vim'
Bundle 'croaker/mustang-vim'
Bundle 'tomasr/molokai'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jonathanfilip/vim-lucius'
Bundle 'fent/vim-frozen'
" }}}

" Dev ---------------------- {{{
Bundle 'blueyed/colorhighlight.vim'
" }}}

" This had to be disabled for vundle.
filetype plugin indent on

" Syntastic.
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'passive_filetypes': ['html'] }

" Tabularize Mapping.
nnoremap <leader>a= :Tabularize /=<cr>
vnoremap <leader>a= :Tabularize /=<cr>
nnoremap <leader>a: :Tabularize /:<cr>
vnoremap <leader>a: :Tabularize /:<cr>

" Shows the errors window. (e)
nnoremap <silent> <leader>e/ :Errors<cr>

" Enable indent guides on boot and allow colorschemes to style them.
nnoremap <silent> <leader>i :IndentGuidesToggle<cr>
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=1
let g:indent_guides_start_level=2

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-d>"

" YCM
"let g:ycm_add_preview_to_completeopt=0
"let g:ycm_confirm_extra_conf=0
"set completeopt-=preview

" Make f, F, t, T case-insensitive
let g:fanfingtastic_ignorecase = 1

nmap <leader>h :call ColorSyntaxHighlightToggle()<cr>

let g:EasyMotion_leader_key = ',m'

augroup filetype_go
  autocmd!
  autocmd filetype go nnoremap <buffer> <localleader>d
    \ :split <cr>:exe "GoDef"<cr>
augroup END

" Edit snippet files easier.
augroup snippets
  autocmd!
  autocmd FileType javascript
    \ nnoremap <buffer> <localleader>es
    \ :split ~/.vim/bundle/vim-snippets/snippets/javascript.snippets<cr>
  autocmd FileType go
    \ nnoremap <buffer> <localleader>es
    \ :split ~/.vim/bundle/vim-snippets/snippets/go.snippets<cr>
augroup END

let g:vim_markdown_initial_foldlevel=5

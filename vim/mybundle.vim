" Let Vundle manage Vundle.
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'

" Usage -------------------- {{{
Plugin 'scrooloose/syntastic'
Plugin 'danro/rename.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-fugitive'
" }}}

" Mappings ----------------- {{{
Plugin 'scrooloose/nerdcommenter'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'godlygeek/tabular'
Plugin 'tomtom/tlib_vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'dahu/vim-fanfingtastic'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'Valloric/YouCompleteMe'
" }}}

" Environemnts ------------- {{{
Plugin 'moll/vim-node'
Plugin 'fatih/vim-go'
" }}}

" Syntax Highlighting ------ {{{
Plugin 'plasticboy/vim-markdown'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'elzr/vim-json'
Plugin 'lukaszb/vim-web-indent'
Plugin 'kchmck/vim-coffee-script'
Plugin 'vim-scripts/applescript.vim'
Plugin 'vim-scripts/AnsiEsc.vim'
Plugin 'othree/xml.vim'
Plugin 'leafgarland/typescript-vim'
" }}}

" Color schemes ------------ {{{
Plugin 'goatslacker/mango.vim'
Plugin 'croaker/mustang-vim'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'fent/vim-frozen'
" }}}

" Dev ---------------------- {{{
Plugin 'blueyed/colorhighlight.vim'
" }}}

" This had to be disabled for vundle.
call vundle#end()
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
set completeopt-=preview

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

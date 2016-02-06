" Let Vundle manage Vundle.
filetype off
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Usage -------------------- {{{
Plugin 'scrooloose/syntastic'
Plugin 'danro/rename.vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/PreserveNoEOL'
Plugin 'ciaranm/detectindent'
Plugin 'jiangmiao/auto-pairs'
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
Plugin 'tpope/vim-unimpaired'
" }}}

" Environemnts ------------- {{{
Plugin 'moll/vim-node'
Plugin 'csscomb/vim-csscomb'
Plugin 'maksimr/vim-jsbeautify'
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
Plugin 'groenewege/vim-less'
Plugin 'mustache/vim-mustache-handlebars'
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

" Misc --------------------- {{{
Bundle 'junegunn/vim-emoji'
" }}}

" This had to be disabled for vundle.
call vundle#end()
filetype plugin indent on

" Syntastic.
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'passive_filetypes': ['html', 'java'] }

" Tabularize Mapping.
nnoremap <leader>a= :Tabularize /=<cr>
vnoremap <leader>a= :Tabularize /=<cr>
nnoremap <leader>a: :Tabularize /:<cr>
vnoremap <leader>a: :Tabularize /:<cr>
nnoremap <leader>a; :Tabularize /:<cr>
vnoremap <leader>a; :Tabularize /:<cr>

" Shows the errors window. (e)
nnoremap <silent> <leader>e/ :Errors<cr>

" Enable indent guides on boot and allow colorschemes to style them.
nnoremap <silent> <leader>i :IndentGuidesToggle<cr>
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=1
let g:indent_guides_start_level=2

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-d>"
let g:UltiSnipsJumpBackwardTrigger="<c-s>"

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

" vim-go
let g:go_doc_keywordprg_enabled = 0

" compile coffeescript
augroup coffeescript
  autocmd!
  autocmd FileType coffee
    \ nnoremap <buffer> <localleader>c :CoffeeCompile<cr>
  autocmd FileType coffee
    \ vnoremap <buffer> <localleader>c :CoffeeCompile<cr>
augroup END

" don't insert EOL if not already there
let g:PreserveNoEOL = 1

" Detect indent
augroup detect_indent
  autocmd!
  autocmd BufReadPost * :DetectIndent 
augroup END

" Fly mode
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = 'µ'

" Update git-gutter always
let g:gitgutter_realtime = 1
set updatetime=500

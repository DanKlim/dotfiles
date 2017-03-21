" Let Vundle manage Vundle.
filetype off
call plug#begin('~/.vim/plugged')

" Usage -------------------- {{{
Plug 'neomake/neomake'
let g:neomake_error_sign = {
  \ 'text': 'E',
  \ 'texthl': 'ErrorMsg',
  \ }
let g:neomake_warning_sign = {
  \ 'text': 'W',
  \ 'texthl': 'WarningMsg',
  \ }
let g:neomake_javascript_enabled_makers = ['eslint']
augroup neomake_group
  autocmd!
  autocmd! BufWritePost *.js,*.coffee,*.css,*.scss,*.py,*.ts :Neomake
augroup END
Plug 'jaawerth/neomake-local-eslint-first'

Plug 'sbdchd/neoformat'
autocmd BufWritePre *.js Neoformat
autocmd FileType javascript set formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
let g:neoformat_try_formatprg = 1

Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-sleuth'

Plug 'tpope/vim-fugitive'

Plug 'vim-scripts/PreserveNoEOL'
let g:PreserveNoEOL = 1

Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<C-b>'

Plug 'itchyny/lightline.vim'
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive' ],
  \             [ 'readonly', 'filename', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ], [ 'percent' ] ],
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \ },
  \ }
function! LightlineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction
set laststatus=2
set noshowmode
" }}}

" Mappings ----------------- {{{
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'

Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <leader>f <Plug>(easymotion-bd-f)
map <leader>l <Plug>(easymotion-bd-jk)

Plug 'godlygeek/tabular'
nnoremap <leader>a= :Tabularize /=<cr>
vnoremap <leader>a= :Tabularize /=<cr>
nnoremap <leader>a: :Tabularize /:<cr>
vnoremap <leader>a: :Tabularize /:<cr>
nnoremap <leader>a; :Tabularize /:<cr>
vnoremap <leader>a; :Tabularize /:<cr>

Plug 'dahu/vim-fanfingtastic'
let g:fanfingtastic_ignorecase = 1

Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'lfilho/cosco.vim'
augroup cosco
  autocmd!
  autocmd FileType javascript,typescript,css,scss,json nnoremap <silent> ;; :call cosco#commaOrSemiColon()<cr>
  autocmd FileType javascript,typescript,css,scss,json inoremap <silent> ;; <c-o>:call cosco#commaOrSemiColon()<cr>
augroup END

Plug 'jeetsukumaran/vim-indentwise'
map [2 <Plug>(IndentWisePreviousLesserIndent)
map [3 <Plug>(IndentWisePreviousEqualIndent)
map [4 <Plug>(IndentWisePreviousGreaterIndent)
map ]2 <Plug>(IndentWiseNextLesserIndent)
map ]3 <Plug>(IndentWiseNextEqualIndent)
map ]4 <Plug>(IndentWiseNextGreaterIndent)
map [5 <Plug>(IndentWiseBlockScopeBoundaryBegin)
map ]5 <Plug>(IndentWiseBlockScopeBoundaryEnd)

Plug 'vim-scripts/ZoomWin'

Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
let g:colorscheme_switcher_keep_background = 1

Plug 'mileszs/ack.vim'
let g:ackprg = 'ag --vimgrep'
" }}}

" Environemnts ------------- {{{
Plug 'moll/vim-node'
Plug 'maksimr/vim-jsbeautify'

Plug 'fatih/vim-go'
let g:go_doc_keywordprg_enabled = 0
augroup filetype_go
  autocmd!
  autocmd FileType go nnoremap <buffer> <localleader>d
    \ :split <cr>:exe "GoDef"<cr>
augroup END

Plug 'JamshedVesuna/vim-markdown-preview'
let vim_markdown_preview_github=1

Plug 'tmux-plugins/vim-tmux-focus-events'
" }}}

" Syntax Highlighting ------ {{{
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_initial_foldlevel=5

Plug 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1

Plug 'jelera/vim-javascript-syntax'
Plug 'elzr/vim-json'
Plug 'lukaszb/vim-web-indent'

Plug 'kchmck/vim-coffee-script'
augroup coffeescript
  autocmd!
  autocmd FileType coffee
    \ nnoremap <buffer> <localleader>c :CoffeeCompile<cr>
  autocmd FileType coffee
    \ vnoremap <buffer> <localleader>c :CoffeeCompile<cr>
augroup END

Plug 'vim-scripts/applescript.vim'
Plug 'othree/xml.vim'
Plug 'leafgarland/typescript-vim'
Plug 'groenewege/vim-less'
Plug 'mustache/vim-mustache-handlebars'
Plug 'ericpruitt/tmux.vim'
" }}}

" Color schemes ------------ {{{
Plug 'goatslacker/mango.vim'
Plug 'chriskempson/base16-vim'
Plug 'fent/vim-frozen'
Plug 'junegunn/seoul256.vim'
" }}}

" Dev ---------------------- {{{
Plug 'chrisbra/Colorizer'
nmap <leader>h :ColorToggle<cr>
" }}}

" Misc --------------------- {{{
Plug 'vim-scripts/AnsiEsc.vim'
Plug 'junegunn/vim-emoji'
" }}}

" This had to be disabled for vundle.
call plug#end()
filetype plugin indent on

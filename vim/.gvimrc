" Remove toolbar.
set guioptions-=T

" Remove righthand scrollbar.
set guioptions-=r

" Remove lefthand scrollbar.
set guioptions-=L
set guifont=Menlo\ Regular:h14

" Cool color scheme.
color base16-atelierlakeside
set transparency=15

" Disable this so I can use the <d-l> shortcut
macmenu &Tools.List\ Errors key=<nop>

" Change tabs.
"macm Window.Select\ Previous\ Tab key=<D-S-H>
"macm Window.Select\ Next\ Tab	key=<D-S-L>
map <D-1> 1gt
map <D-2> 2gt
map <D-3> 3gt
map <D-4> 4gt
map <D-5> 5gt
map <D-6> 6gt
map <D-7> 7gt
map <D-8> 8gt
map <D-9> :tablast<CR>

" Highlight the line the cursor is on to find it easier.
set cursorline

" Fix relative paths for parents in tab.
let &guitablabel="%!RelativePathString(expand('%:p'))"

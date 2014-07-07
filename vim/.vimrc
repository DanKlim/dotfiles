" First load settings that will be used in all environments.
source ~/.vim/shared.vim

" Load bundles.
source ~/.vim/mybundle.vim

" Do not keep a backup file.
if has("vms")
  set nobackup
else
  set backup
endif
set directory=~/.vim/swp
set backupdir=~/.vim/backup

" Set color scheme.
set t_Co=256
set background=dark
syntax on
color mango

" Source settings files ------------------ {{{
if !exists("*Resource")
  function Resource()
    :source ~/.vimrc
    if has("gui_running")
      :source ~/.gvimrc
    endif
    echo "vimrc reloaded"
  endfunction
  nnoremap <leader>sv :call Resource()<cr>
endif

" Edit settings files easier.
nnoremap <leader>er :split ~/.vim/.vimrc<cr>
nnoremap <leader>ev :split ~/.vim/shared.vim<cr>
nnoremap <leader>eb :split ~/.vim/mybundle.vim<cr>
" }}}
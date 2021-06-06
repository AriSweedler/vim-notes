""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:loaded_sweedlerNotes')
  finish
endif
let g:loaded_sweedlerNotes = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""" Copy Named Folds """"""""""""""""""""""""""""" {{{
" Copy a named fold from the other window into register @0 then paste it
function! notes#getNamedFold(pattern)
  execute 'wincmd w'
  " Open folds in the other window so we can use `Va{` as intended
  let l:saved_foldlevel = &foldlevel
  let &foldlevel = 10
  execute 'silent keeppatterns global/^{\{3,3} ' . a:pattern . '/normal! Va{"0y'
  let &foldlevel = l:saved_foldlevel
  execute 'wincmd w'
  .put 0
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:loaded_sweedlerNotes')
  finish
endif
let g:loaded_sweedlerNotes = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""" notes autolaod """""""""""""""""""""""""""""" {{{
""""""""""""""""""""""""""""" Initialize notes """"""""""""""""""""""""""""" {{{
" This is where I put all my default kepmappings. If I wanted to make this a
" real plugin, I would check to make sure I'm not overriding stuff first
function! notes#init()
  """""""""""""""""""""""""""""""" bangmaps """""""""""""""""""""""""""""" {{{
  " Repeat the last action. If the last action has been cleared, then 'DO' --> 'DONE'
  nnoremap <silent> ! :call notes#banglist#bang()<CR>
  " Not sure how to do this one ==> '?'
  nnoremap <silent> ? :call notes#banglist#non_bang('DO', 'Backburner')<CR>
  " I want to add work to my plate ==> '+'
  nnoremap <silent> + :call notes#banglist#non_bang('Backburner', 'DO')<CR>
  " Reset actions
  nnoremap <silent> _ :call notes#banglist#reset()<CR>
  " Find the next item
  nnoremap <silent> [! :call notes#banglist#search('DO', 'forward')<CR>
  nnoremap <silent> ]! :call notes#banglist#search('DO', 'backward')<CR>
  nnoremap <silent> [x :call notes#banglist#search('DONE', 'forward')<CR>
  nnoremap <silent> ]x :call notes#banglist#search('DONE', 'backward')<CR>
  nnoremap <silent> [? :call notes#banglist#search('Backburner', 'forward')<CR>
  nnoremap <silent> ]? :call notes#banglist#search('Backburner', 'backward')<CR>
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
  """"""""""""""""""""""""""""""" Notes stuff """""""""""""""""""""""""""" {{{
  " Bring TODOs to today's file, delete DONE banglist items, open the TODOs fold
  nnoremap <Leader>T :call notes#getNamedFold('TODOs') <Bar> call notes#banglist#global('DONE', 'delete') <Bar> FoldOpen TODOs<CR>

  command! TYesterday call notes#yesterday#openHelper('tabedit', 1)
  " Go to yesterday (<Leader>y) or tomorrow (<Leader>Y). Takes a count.
  nnoremap [y :<C-u>call notes#yesterday#openHelper('edit', v:count)<CR>
  nnoremap ]y :<C-u>call notes#yesterday#openHelper('edit', (v:count?0:-1) - v:count)<CR>
  " Trying out using brackets instead of leader/capitalization
  nnoremap <Leader>y :<C-u>call notes#yesterday#openHelper('edit', v:count)<CR>
  nnoremap <Leader>Y :<C-u>call notes#yesterday#openHelper('edit', (v:count?0:-1) - v:count)<CR>

  " Reset notes state when changing days
  command! Notes only <Bar> GoNotesToday <Bar> vsplit <Bar> GoNotesYesterday <Bar> wincmd h
  command! -bar GoNotesToday execute "edit " . system('tail -1 .daykeeper | tr -d "\n"') . ".*"
  command! -bar GoNotesYesterday execute "edit " . system('tail -2 .daykeeper | head -1 | tr -d "\n"') . ".*"

  " Jump straight to a specific named fold. FoldOpen commands
  command! -nargs=1 FoldOpen let g:notes_foldo = <q-args> <Bar> keeppatterns silent g/\c^{\{3,3} <args>/normal zx
  nnoremap <Leader>FT :FoldOpen TODOs<CR>
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
endfunction
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

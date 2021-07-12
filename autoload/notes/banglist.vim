"""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
"if exists('g:autoloaded_sweedlerNotes_banglist')
"  finish
"endif
"let g:autoloaded_sweedlerNotes_banglist = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""" banglist autoload """""""""""""""""""""""""""" {{{
""""""""""""""""""""""""""" useful script globals """""""""""""""""""""""""" {{{
let g:notes#banglist#pattern_start = '\* \<\zs'
let g:notes#banglist#pattern_end = '\ze\>.*!'
" Returns a regex to select for banglist items. Of the form
" "\* \<\zsITEM\ze\>.*!" instead of just "ITEM".
function! notes#banglist#pat(name)
  return g:notes#banglist#pattern_start . a:name . g:notes#banglist#pattern_end
endfunction
let s:should_slide = 0
let s:src_word = ''
let s:dst_word = ''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""""" bang """"""""""""""""""""""""""""""""""" {{{
function! notes#banglist#bang()
  let l:unmoved = lib#cursorUnmoved('banglist')
  let l:prev_action = (s:src_word != '')

  " Set up the cache properly
  let s:should_slide = l:unmoved && l:prev_action
  if ! s:should_slide
    let s:src_word = 'DO'
    let s:dst_word = 'DONE'
  endif

  " Execute the action
  call notes#banglist#subslide(s:should_slide, s:src_word, s:dst_word)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""" Any non_bang movement """"""""""""""""""""""""" {{{
function! notes#banglist#non_bang(src_w, dst_w)
  let l:unmoved = lib#cursorUnmoved('banglist')

  " Set up the cache properly
  let s:src_word = a:src_w
  let s:dst_word = a:dst_w
  let s:should_slide = l:unmoved

  " Execute the action
  call notes#banglist#subslide(s:should_slide, s:src_word, s:dst_word)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""" subslide """"""""""""""""""""""""""""""""" {{{
" Finds the next line containing src and changes it to dst. If 'slide' is set to
" true, first changes this line from dst to src.
"
" Moving to where we marked our last position will cause a slide, regardless
" of what the text under cursor says. `!uW!` will this do strange things.
function! notes#banglist#subslide(slide, src, dst)
  " Move to the start of the line before executing forward search, so
  " invocations work linewise isntead of characterwise
  normal 0

  " If this action is a slide, then undo the substitution on this line. Then,
  " move to the end of the line (past the fresh src pattern) so the next
  " search does something useful.
  if a:slide
    execute "substitute/" . notes#banglist#pat(a:dst) . "/" . a:src . "/e 1"
    normal $
  endif

  " Find next src pattern, substitute, and place cursor on dst
  call notes#banglist#search(a:src)
  execute "substitute/" . notes#banglist#pat(a:src) . "/" . a:dst . "/e 1"
  call notes#banglist#search(a:dst)

  " Invoke to set our location, not determine if we've moved since last call.
  let _ = lib#cursorUnmoved('banglist')
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""""" reset """""""""""""""""""""""""""""""""" {{{
function! notes#banglist#reset()
  " Clear all state
  unlet g:lib#prev_cur_pos['banglist']
  let s:src_word = ''
  let s:dst_word = ''
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""" search """""""""""""""""""""""""""""""""" {{{
function! notes#banglist#search(word, ...)
  let l:search_flags = (a:0 == 1 && a:1 == 'backward') ? 'b' : ''
  let l:pat = notes#banglist#pat(a:word)
  call search(l:pat, l:search_flags)
  " Open folds if need be
  normal zx
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""" backburner highlight """"""""""""""""""""""""""" {{{
" Toggle between 27 and 238. Half optimized for literally no reason haha !
let g:notes#banglist#bb_color = 238
function! notes#banglist#toggle_backburner_highlight()
  let g:notes#banglist#bb_color = 27 + (238-27)*(g:notes#banglist#bb_color == 27)
  execute "highlight notesBackburner term=standout ctermfg=" . g:notes#banglist#bb_color
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""" DONE highlight """""""""""""""""""""""""""""" {{{
" Toggle between 23 and 31. Half optimized for literally no reason haha !
let g:notes#banglist#dd_color = 23
function! notes#banglist#toggle_done_highlight()
  let g:notes#banglist#dd_color = 23 + (31-23)*(g:notes#banglist#dd_color == 23)
  execute "highlight notesDONE term=standout ctermfg=" . g:notes#banglist#dd_color
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""" global """""""""""""""""""""""""""""""""" {{{
" Acts just like :global, but only checks for banglist items. This is stricter
" and more semantically useful sometimes
function! notes#banglist#global(src, command)
  let l:command = printf("silent global/%s/%s", notes#banglist#pat(a:src), a:command)
  execute l:command
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

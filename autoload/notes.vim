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
  " I finished something! == '!'
  nnoremap ! :call notes#banglist#controller('DO', 'DONE')<CR>
  " Not sure how to do this one ==> '?'
  nnoremap ? :call notes#banglist#controller('DO', 'Backburner')<CR>
  " I want to add work to my plate ==> '+'
  nnoremap + :call notes#banglist#controller('Backburner', 'DO')<CR>

  " Break sequences
  nnoremap _ :unlet g:lib#prev_cur_pos['banglist']<CR>
  " Find the next DO
  nnoremap <Leader>! :call notes#banglist#controller('DO')<CR>
  nnoremap <Leader>? :call notes#banglist#toggle_backburner_highlight()<CR>

  " Bring TODOs to today's file, delete DONE banglist items, open the TODOs fold
  nnoremap <Leader>T :call notes#getNamedFold('TODOs') <Bar> call notes#banglist#global('DONE', 'delete') <Bar> FoldOpen TODOs<CR>

  command! TYesterday call notes#yesterday#openHelper('tabedit', 1)
  " Go to yesterday (<Leader>y) or tomorrow (<Leader>Y). Takes a count.
  nnoremap <Leader>y :<C-u>call notes#yesterday#openHelper('edit', v:count)<CR>
  nnoremap <Leader>Y :<C-u>call notes#yesterday#openHelper('edit', (v:count?0:-1) - v:count)<CR>

  " Give access to Today/Yesterday Commands to reset journal state
  command! NotesToday execute "edit " . system('tail -1 .daykeeper | tr -d "\n"') . ".*"
  command! NotesYesterday execute "edit " . system('tail -2 .daykeeper | head -1 | tr -d "\n"') . ".*"

  " Remap gx to my improved(?) function
  nnoremap gx :call notes#openLink("open")<CR>
  nnoremap gX :call notes#openLink("yank")<CR>

  " FoldOpen commands
  command! -nargs=1 FoldOpen let g:notes_foldo = <q-args> <Bar> keeppatterns silent g/\c^{\{3,3} <args>/normal zx
  nnoremap <Leader>FT :FoldOpen TODOs<CR>

  " Change curly quotes into regular quotes and stuff
  command! FixPastedPDF keeppatterns call notes#fixPastedPDF()

  " Copy a link to a clipboard then invoke <C-k> to make a word say that
  inoremap <C-k> <C-c>"kdiWa[<C-r>k](<C-r>*)
  nnoremap <C-k> "kdiWa[<C-r>k](<C-r>*)
  vnoremap <C-k> "kda[<C-r>k](<C-r>*)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""""" Links """""""""""""""""""""""""""""""""" {{{
" Open the URL under cursor. Or the last link on the line
" Links are of the form [title](URL)
function! notes#openLink(arg)
  " Try to find link under cursor
  let l:link_regex = '\[\_[^]]*](\([^)]*\))'
  let l:link = substitute(expand('<cWORD>'), l:link_regex, '\1', '')

  " If no substitution is made, no link was found.
  " Try to find last link on the current line
  if l:link == expand('<cWORD>')
    "echo "No link under cursor. Trying to open last link on this line"
    let l:line_link_regex = '^'. '.*' . '\[' . '\_[^]]*' . '](' . '\([^[]*\)' . ')' . '.*'
    let l:link = substitute(getline('.'), l:line_link_regex, '\1', '')
  endif

  " If no substitution is made, no link was found.
  if l:link == getline('.')
    echom "ERROR: No link found on this line. Giving up"
    return
  endif

  if a:arg == "open"
    execute '!open "' . l:link . '"'
  elseif a:arg == "yank"
    call setreg('*', l:link)
    echom "'" . l:link . "' placed on clipboard"
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""" Copy Named Folds """"""""""""""""""""""""""""" {{{
" Copy a named fold from the other window into register @0 then paste it
function! notes#getNamedFold(pattern)
  execute 'wincmd w'
  " Open folds in the other window so we can use `Va{` as intended
  let l:saved_foldlevel = &foldlevel
  let &foldlevel = 10
  execute 'silent keeppatterns global/^{\{3,3} ' . a:pattern . '/normal Va{"0y'
  let &foldlevel = l:saved_foldlevel
  execute 'wincmd w'
  .put 0
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""" For copy/pasting from PDFs """""""""""""""""""""""" {{{
" For copy/pasting that BS
function! notes#fixPastedPDF()
  %substitute/â/-/e
  %substitute/â/'/e
  %substitute/â/"/e
  %substitute/â/"/e
  %substitute/â¢/*/e
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

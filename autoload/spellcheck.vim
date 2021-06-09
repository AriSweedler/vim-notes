""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
" TODO disabled
if exists('g:loaded_sweedlerNotesSpellcheck')
  "finish
endif
let g:loaded_sweedlerNotesSpellcheck = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
function! spellcheck#start()
  echom "Spellcheck started"
  " While there're more spellings to check
endfunction

" TODO instead of `autocorrect` what if I could display the top N spellings
" I can use 'complete_info(["spell"])' & slice it.
let s:choices = []
let s:choices += [["&` code literal", function("spellcheck#surround_backticks")]]
let s:choices += [["&_ ignore", function("spellcheck#surround_underline")]]
let s:choices += [["&autocorrect", function("spellcheck#zEqual")]]
let s:choices += [["&learn word", function("spellcheck#zg")]]

function! spellcheck#surround_backticks()
  echom "TODO backticks"
endfunction

function! spellcheck#surround_underline()
  echom "TODO underline"
endfunction

function! spellcheck#zEqual()
  echom "TODO z="
endfunction

function! spellcheck#zg()
  echom "TODO zg"
endfunction

function! s:GetChoicesString()
  return mapnew(s:choices, 'v:val[0]')->join("\n")
endfunction

function! spellcheck#next()
  let msg = "What do you wanna do?"

  let choice = confirm(msg, s:GetChoicesString())
  let MyFunc = s:choices[choice-1][1]
  echom "You wanted " . choice . " which corresponds to "
  echom l:MyFunc
  call l:MyFunc()
endfunction

" call spellcheck#next()

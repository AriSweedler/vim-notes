" Indent settings
setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal spell

" Textwrap at 80 columns
call lib#change_text_width(80)

" Set folding for 3-backtick markdown divider block
setlocal foldmethod=marker foldmarker={{{,}}}
setlocal foldlevel=1

" For bulleted lists (and blockquotes)
setlocal autoindent
setlocal comments=fb:*,b:>
setlocal formatoptions=tcqj
setlocal formatlistpat=^\\s*[-*+]\\s\\+\\ze\\S

" This allows links to be displayed prettier
setlocal nowrap
setlocal conceallevel=2
setlocal concealcursor=nc

"Show how deep in folds each line is in the left columns
setlocal foldcolumn=2

"""""""""""""""""""""""" Initialize notes mappings """"""""""""""""""""""" {{{
" Initialize all the mappings for `.notes` files.
" This plugin OWNS .notes files, lol. A user could configure this if they want
" something else.
"""""""""""""""""""""""""""""""" bangmaps """""""""""""""""""""""""""""" {{{
" Repeat the last action. If the last action has been cleared, then 'DO' --> 'DONE'
nnoremap <buffer> <silent> ! :call notes#banglist#bang()<CR>
" Not sure how to do this one ==> '?'
nnoremap <buffer> <silent> ? :call notes#banglist#non_bang('DO', 'Backburner')<CR>
" I want to add work to my plate ==> '+'
nnoremap <buffer> <silent> + :call notes#banglist#non_bang('Backburner', 'DO')<CR>
" Reset actions
nnoremap <buffer> <silent> _ :call notes#banglist#reset()<CR>
" Find the next item
nnoremap <buffer> <silent> [! :call notes#banglist#search('DO', 'backward')<CR>
nnoremap <buffer> <silent> ]! :call notes#banglist#search('DO', 'forward')<CR>
nnoremap <buffer> <silent> [x :call notes#banglist#search('DONE', 'backward')<CR>
nnoremap <buffer> <silent> ]x :call notes#banglist#search('DONE', 'forward')<CR>
nnoremap <buffer> <silent> [? :call notes#banglist#search('Backburner', 'backward')<CR>
nnoremap <buffer> <silent> ]? :call notes#banglist#search('Backburner', 'forward')<CR>

" Make a bullet a banglist item
nnoremap <buffer> <silent> <Leader>! $?\*<CR>wiDO <C-c>A !<C-c>:nohlsearch<CR>

" Toggle colors
nnoremap <buffer> <silent> <Leader>? :call notes#banglist#toggle_backburner_highlight()<CR>
nnoremap <buffer> <silent> <Leader><Leader>? :call notes#banglist#toggle_done_highlight()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""" Notes stuff """""""""""""""""""""""""""" {{{
" Bring TODOs to today's file, delete DONE banglist items, open the TODOs fold
nnoremap <buffer> <silent> <Leader>T :call notes#getNamedFold('TODOs') <Bar> call notes#banglist#global('DONE', 'delete') <Bar> FoldOpen TODOs<CR>

command! TYesterday call notes#yesterday#openHelper('tabedit', 1)
" Go to yesterday (<Leader>y) or tomorrow (<Leader>Y). Takes a count.
nnoremap <buffer> [y :<C-u>call notes#yesterday#openHelper('edit', v:count)<CR>
nnoremap <buffer> ]y :<C-u>call notes#yesterday#openHelper('edit', (v:count?0:-1) - v:count)<CR>
" Trying out using brackets instead of leader/capitalization
nnoremap <buffer> <Leader>y :<C-u>call notes#yesterday#openHelper('edit', v:count)<CR>
nnoremap <buffer> <Leader>Y :<C-u>call notes#yesterday#openHelper('edit', (v:count?0:-1) - v:count)<CR>

" Reset notes state when changing days
command! Notes only <Bar> GoNotesToday <Bar> vsplit <Bar> GoNotesYesterday <Bar> wincmd h
command! -bar GoNotesToday execute "edit " . system('tail -1 .daykeeper | tr -d "\n"') . ".*"
command! -bar GoNotesYesterday execute "edit " . system('tail -2 .daykeeper | head -1 | tr -d "\n"') . ".*"

" Jump straight to a specific named fold. FoldOpen commands
command! -nargs=1 FoldOpen let g:notes_foldo = <q-args> <Bar> keeppatterns silent g/\c^{\{3,3} <args>/normal zx
nnoremap <buffer> <Leader>FT :FoldOpen TODOs<CR>

" Horizontal line rule
nnoremap <Leader>- o----<C-c>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

""""""""""""""""""""""""""""""" Include guard """""""""""""""""""""""""""""" {{{
if exists('g:autoloaded_sweedlerNotes_yesterday')
  finish
endif
let g:autoloaded_sweedlerNotes_yesterday = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""""""""""" Yesterday """""""""""""""""""""""""""""""" {{{
""""""""""""""""""""""""""""""" Get file name """""""""""""""""""""""""""""" {{{
function! notes#yesterday#getFileName(...)
  " Get the 1st optional argument (default to 1 if no value provided)
  let l:days_ago = get(a:, 1, 1)
  if l:days_ago == 0
    let l:days_ago = 1
  endif

  " Take the n'th line from the end in our .datekeeper file

  " Get the line number in the datekeeper file for today's file
  let filename = expand("%:.:r")->substitute("/", "\\\\/", "g")
  let line_number = system('sed -n "/' . l:filename . '/=" .datekeeper')
  let desired_line_number = l:line_number - l:days_ago

  " Don't try to open a file we haven't written yet
  if l:desired_line_number < 1
    let l:desired_line_number = 1
  endif

  " Return the contents of the desired line. For a .datekeeper file, this should
  " be a filename without an extension
  let get_line_contents = "head -" . l:desired_line_number . " .datekeeper | tail -1 | tr -d '\n'"
  return system(l:get_line_contents)
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
""""""""""""""""""""""""" Open an older day's file """"""""""""""""""""""""" {{{
function! notes#yesterday#openHelper(open_method, days_ago)
  " open up the desired file
  let l:file = notes#yesterday#getFileName(a:days_ago) . ".*"
  let l:cmd = printf('%s %s', a:open_method, l:file)
  execute l:cmd

  " If we invoked 'edit', then delete the previous buffer from the list
  if a:open_method == 'edit'
    bdelete #
  endif

  " If we're looking at a named fold, open that up
  if exists("g:notes_foldo")
    execute 'FoldOpen ' . g:notes_foldo
  endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

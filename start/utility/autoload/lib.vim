" Helper function to check if the cursor has moved since the last invocation
" of this function.
let g:lib#prev_cur_pos = {}
function! lib#cursorUnmoved(tag)
  let prev = exists("g:lib#prev_cur_pos[a:tag]") ? g:lib#prev_cur_pos[a:tag] : [0]
  let answer = (l:prev == getpos('.'))

  " Update tag's prev_cur_pos and return the answer
  let g:lib#prev_cur_pos[a:tag] = getpos('.')
  return answer
endfunction

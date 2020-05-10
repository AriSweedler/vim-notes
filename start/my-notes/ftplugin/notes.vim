" TODO can't call ChangeTextWidth unless it's defined in this plugin
" TODO Make a different plugin in this pack to do this?
call ChangeTextWidth(80)

setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
setlocal spell

" Set folding for 3-backtick markdown divider block
setlocal foldmethod=marker foldmarker={{{,}}}
setlocal foldlevel=1

" For bulleted lists
setlocal autoindent
setlocal comments=fb:*
setlocal formatoptions=tcqj
setlocal formatlistpat=^\\s*[-*+]\\s\\+\\ze\\S

" This allows links to be displayed prettier
setlocal nowrap
setlocal conceallevel=2
setlocal concealcursor=nc

" Invoke my plugin
call notes#init()

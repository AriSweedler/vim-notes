" Give the 'notes' filetype to explicitly named .notes files. Or if we've opened
" up a 'md' file in a NOTE_BASE
autocmd BufNewFile,BufRead *.notes set filetype=notes
autocmd BufWritePost,BufNewFile,BufRead $NOTE_BASE/*/*/*.md set filetype=notes

"""""""""""""""""""""" Syntax file for 'notes' filetype """"""""""""""""""""""
if exists("b:current_syntax")
  finish
endif

runtime! syntax/markdown.vim

""""""""""""""""""""""" syntax & highlight group links """"""""""""""""""""{{{
" {{{ Fold
syntax match notesNamedFoldStart +^{{{+ nextgroup=notesNamedFoldHeader,notesLogStart
syntax match notesNamedFoldHeader +[^!]*+ contained containedin=NONE contains=@NoSpell
" {{{ fold-marker is not as good as fold-syntax when the marker is data :c
syntax region notesNamedFoldBodyNospell start=+!@+ matchgroup=notesNamedFoldEnd end=+^[{}]\{3}+me=s-1 contains=@NoSpell,@notesText,notesNamedFoldStart
syntax match notesNamedFoldEnd +^}}}+

highlight link notesNamedFoldStart notesNamedFoldBracket
highlight link notesNamedFoldHeader notesHeader
highlight link notesNamedFoldEnd notesNamedFoldBracket
" }}}
" {{{ Define the "TODO" keyword
syntax case ignore
syntax keyword notesTodo TODO
syntax case match
" }}}
" {{{ Define the horizontal rule
syntax match notesHorizontalRule /^-\{3,}$/
highlight link notesHorizontalRule notesBullet
" }}}
" {{{ Links
"TODO rewrite this guy so we can have a top-level link object with 2 kids - text and URL
syntax cluster notesLink contains=notesLinkText
" Literal [
" THEN 0-width: zero-or-more of 'NOT ]'
" THEN 0-width: Literal ](
syntax region notesLinkText matchgroup=notesLinkTextDelimiter start=+\[\%(\_[^]]*](\)\@=+ matchgroup=notesLinkTextDelimiter end=+]+ nextgroup=notesLinkURL contains=@notesWeightedText
syntax region notesLinkURL matchgroup=notesLinkTextDelimiter start=+(+ matchgroup=notesLinkTextDelimiter skip=+\(\\[ ()]\|([^)]*)\)+ end=+\%()\|\_s\)+ contained containedin=NONE contains=@NoSpell conceal
highlight link notesLinkTextDelimiter notesDelimiterHidden
highlight link notesLinkText Underlined
" }}}
" {{{ Priority for notesListMarker
syntax match notesListMarker /^\s*[-*+] \%(\S\)\@=/ nextgroup=@notesBangList
syntax match notesListNumber /^\s*\d\+[.):-] \%(\S\)\@=/
highlight link notesListMarker notesBullet
highlight link notesListNumber notesBullet

" Special items to define a bullet as a BangList item
syntax cluster notesBangList contains=notesBangListDO,notesBangListDONE,notesBangListBackburner
syntax region notesBangListDO start=/DO\>/ end=/!$/ oneline contains=@NoSpell,@notesTextUnweighted,@notesTextWeightedDO contained
syntax region notesBangListDONE start=/DONE\>/ end=/!$/ oneline contains=@NoSpell,@notesTextUnweighted,@notesTextWeightedDONE contained
syntax region notesBangListBackburner start=/Backburner\>/ end=/!$/ oneline contains=@NoSpell,@notesText contained

highlight link notesBangListDO notesDO
highlight link notesBangListDONE notesDONE
highlight link notesBangListBackburner notesBackburner
" }}}
" {{{ Italics/Bold/literals
syntax region notesItalic matchgroup=notesItalicDelimiter start="\*\%(\S\)\@=" matchgroup=notesItalicDelimiter end="\%(\S\)\@<=\*" keepend concealends
syntax region notesItalicDO matchgroup=notesItalicDelimiter start="\*\%(\S\)\@=" matchgroup=notesItalicDelimiter end="\%(\S\)\@<=\*" keepend concealends contained containedin=notesBangListDO
syntax region notesItalicDONE matchgroup=notesItalicDelimiter start="\*\%(\S\)\@=" matchgroup=notesItalicDelimiter end="\%(\S\)\@<=\*" keepend concealends contained containedin=notesBangListDONE

syntax region notesBold matchgroup=notesBoldDelimiter start="\*\*\%(\S\)\@=" matchgroup=notesBoldDelimiter end="\%(\S\)\@<=\*\*" keepend concealends
syntax region notesBoldDO matchgroup=notesBoldDelimiter start="\*\*\%(\S\)\@=" matchgroup=notesBoldDelimiter end="\%(\S\)\@<=\*\*" keepend concealends contained containedin=notesBangListDO
syntax region notesBoldDONE matchgroup=notesBoldDelimiter start="\*\*\%(\S\)\@=" matchgroup=notesBoldDelimiter end="\%(\S\)\@<=\*\*" keepend concealends contained containedin=notesBangListDONE

syntax region notesSlang matchgroup=notesSlangDelimeter start="\<_\S\@=" matchgroup=notesSlangDelimeter end="\S\@<=_" keepend concealends contains=@NoSpell

syntax region notesCodeLiteral matchgroup=notesCodeLiteralDelimiter start="`\%(\S\)\@=" matchgroup=notesCodeLiteralDelimiter skip="\\`" end="\%(\S\)\@<=`" keepend concealends contains=@NoSpell,notesEscapedBackslash
syntax match notesEscapedBackslash /\\`/ conceal cchar=`
" Not making separate syntax items for these boys. Too messy, not worth it. I
" should even remove the DO/DONE weighted text specials.
"
" I should clean this whole file up, actually. Get some BNF for this language
" & auto-generate this syntax file from that. That would be A W E S O M E...
" but... gotta actually fully appreciate and understand all of the annoying
" sillies about this DSL, first. I can do it. Just will take time and I'll
" need to blog about it. Creating examples along the way.
highlight Conceal ctermbg=240
syntax region notesCodeLiteralDO matchgroup=notesCodeLiteralDelimiter start="`\%(\S\)\@=" matchgroup=notesCodeLiteralDelimiter skip="\\`" end="\%(\S\)\@<=`" keepend concealends contained containedin=notesBangListDO contains=@NoSpell,notesEscapedBackslash
syntax region notesCodeLiteralDONE matchgroup=notesCodeLiteralDelimiter start="`\%(\S\)\@=" matchgroup=notesCodeLiteralDelimiter skip="\\`" end="\%(\S\)\@<=`" keepend concealends contained containedin=notesBangListDONE contains=@NoSpell,notesEscapedBackslash

syntax cluster notesWeightedTextDelimiter contains=notesItalicDelimiter,notesBoldDelimiter,notesCodeLiteralDelimiter,notesBarDelimiter
syntax cluster notesWeightedText contains=notesItalic,notesBold,notesSlang,notesCodeLiteral,@notesWeightedTextDelimiter,notesTodo
syntax cluster notesTextWeightedDO contains=notesItalicDO,notesBoldDO,notesCodeLiteralDO,@notesWeightedTextDelimiter,notesTodo
syntax cluster notesTextWeightedDONE contains=notesItalicDONE,notesBoldDONE,notesCodeLiteralDONE,@notesWeightedTextDelimiter,notesTodo

highlight notesSlang cterm=underline
highlight notesItalic cterm=italic
highlight notesItalicDO cterm=italic ctermfg=10
highlight notesItalicDONE cterm=italic ctermfg=23

highlight notesBold cterm=bold
highlight notesBoldDO cterm=bold ctermfg=10
highlight notesBoldDONE cterm=bold ctermfg=23

highlight notesCodeLiteral ctermbg=240
highlight notesCodeLiteralDO ctermbg=240 ctermfg=10
highlight notesCodeLiteralDONE ctermbg=240 ctermfg=32

highlight notesSlangDelimeter ctermbg=202
highlight notesItalicDelimiter ctermfg=22
highlight notesBoldDelimiter ctermfg=27
" }}}
" {{{ Codeblocks and blockquotes
syntax region notesCodeblockRegion start="^$\n\%( \{4}\)" end="^\%( \{4}\)\@!" contains=notesCodeblockLiteral keepend fold
syntax match notesCodeblockLiteral /^\%( \{4}\).*$/ms=s+4 contains=@NoSpell contained fold
syntax region notesBlockquote matchgroup=notesBlockquoteDelimiter start="^> " end="$" contains=@NoSpell fold
syntax cluster notesBlocks contains=notesCodeblockRegion,notesBlockquote

highlight link notesCodeblockRegion Normal
highlight link notesCodeblockLiteral notesCodeLiteral
highlight notesBlockquote ctermfg=247
highlight notesBlockquoteDelimiter ctermfg=34
" }}}
syntax cluster notesTextUnweighted contains=notesListMarker,notesHorizontalRule,@notesLink
syntax cluster notesText contains=notesListMarker,notesHorizontalRule,@notesLink,@notesWeightedText
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
""""""""""""""" Colorscheme (give colors to the linked groups) """"""""""""{{{
highlight notesHeader term=bold ctermfg=5
highlight notesSubheader term=bold ctermfg=61
highlight notesNamedFoldBracket ctermfg=89
highlight notesLogBrackets term=bold ctermfg=80
highlight link notesTodo Todo
highlight notesBullet ctermfg=3
highlight notesDO term=standout ctermfg=10
highlight notesDONE term=standout ctermfg=23
highlight notesBackburner term=standout ctermfg=238
highlight notesDelimiterHidden ctermfg=39
highlight notesDelimiterStandout ctermfg=5
highlight notesLinkURL ctermfg=91
highlight link notesCodeLiteralDelimiter notesDelimiterStandout
highlight link notesBarDelimiter notesDelimiterHidden
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

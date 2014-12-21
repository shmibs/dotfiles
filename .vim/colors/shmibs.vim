"Vim color file
"intended for 256 colour term

hi clear

let g:colors_name="shmibs"

hi! Comment    ctermfg=lightblue
hi! Constant   ctermfg=red
hi! CursorLine ctermbg=234
hi! Directory  ctermfg=cyan
hi! Folded     ctermbg=NONE ctermfg=240
hi! Identifier cterm=bold ctermfg=cyan
hi! NonText    ctermbg=234 ctermfg=yellow cterm=bold
hi! PreProc    ctermfg=magenta
hi! Question   ctermfg=green
hi! Statement  ctermfg=yellow
hi! Special    ctermfg=magenta
hi! SpecialKey ctermfg=green
hi! SpellBad   ctermbg=lightred
hi! Title      ctermfg=magenta
hi! Todo       ctermbg=yellow ctermfg=black
hi! Type       ctermfg=green
hi! Underlined ctermfg=magenta cterm=underline



"A => B
hi! link Boolean        Constant
hi! link Character      Constant
hi! link Function       Identifier
hi! link Keyword        Statement
hi! link LineNr         NonText
hi! link Number         Constant
hi! link PreProc        Define
hi! link SpecialChar    Special
hi! link SpecialComment Special
hi! link String         Constant
hi! link StorageClass   Type
hi! link Tag            Special

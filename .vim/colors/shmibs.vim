"Vim color file
"intended for 256 colour term

hi clear

let g:colors_name="shmibs"

hi! Comment    ctermfg=12
hi! Constant   ctermfg=1
hi! CursorLine ctermbg=234
hi! Directory  ctermfg=6
hi! Folded     ctermbg=NONE ctermfg=240
hi! Identifier cterm=bold ctermfg=6
hi! NonText    ctermbg=234 ctermfg=3 cterm=bold
hi! PreProc    ctermfg=5
hi! Statement  ctermfg=3
hi! Special    ctermfg=9
hi! SpecialKey ctermfg=2
hi! SpellBad   ctermbg=9
hi! Title      ctermfg=5
hi! Todo       ctermbg=11 ctermfg=0
hi! Type       ctermfg=2
hi! Underlined ctermfg=5 cterm=underline


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

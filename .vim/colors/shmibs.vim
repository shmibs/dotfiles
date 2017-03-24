"Vim color file
"intended for 256 colour term

hi! clear

let g:colors_name="shmibs"

hi! Comment      ctermfg=12
hi! Constant     ctermfg=red
hi! CursorLine   ctermfg=NONE ctermbg=8 cterm=NONE
hi! CursorLineNr ctermfg=white ctermbg=8 cterm=bold
hi! Directory    ctermfg=cyan
hi! DiffAdd      ctermfg=green ctermbg=NONE cterm=bold
hi! DiffDelete   ctermfg=red ctermbg=NONE cterm=bold
hi! DiffChange   ctermfg=blue ctermbg=NONE cterm=bold
hi! DiffText     ctermfg=black ctermbg=yellow cterm=NONE
hi! Folded       ctermfg=8 ctermbg=NONE
hi! Identifier   cterm=bold ctermfg=cyan
hi! NonText      ctermfg=yellow ctermbg=black cterm=bold
hi! PreProc      ctermfg=magenta
hi! Pmenu        ctermfg=white ctermbg=magenta
hi! PmenuSel     ctermfg=black ctermbg=lightmagenta
hi! Question     ctermfg=green
hi! Statement    ctermfg=yellow
hi! SignColumn   ctermfg=NONE ctermbg=NONE cterm=NONE
hi! Special      ctermfg=magenta
hi! SpecialKey   ctermfg=green
hi! SpellBad     ctermfg=NONE ctermbg=NONE cterm=underline
hi! SpellCap     ctermfg=NONE ctermbg=NONE cterm=NONE
hi! SpellRare    ctermfg=NONE ctermbg=NONE
hi! Title        ctermfg=magenta
hi! Todo         ctermfg=black ctermbg=yellow
hi! Type         ctermfg=green
hi! Underlined   cterm=underline ctermfg=magenta
hi! Visual       ctermbg=8

"A => B
hi! link Boolean        Constant
hi! link Character      Constant
hi! link CursorColumn   CursorLine
hi! link Function       Identifier
hi! link Keyword        Statement
hi! link LineNr         NonText
hi! link Number         Constant
hi! link PreProc        Define
hi! link SpecialChar    Special
hi! link SpecialComment Special
hi! link SpellLocal     SpellBad
hi! link String         Constant
hi! link StorageClass   Type
hi! link Tag            Special

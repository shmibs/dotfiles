""""""""""""""
"  SETTINGS  "
""""""""""""""

syntax on
filetype plugin indent on
set autoindent

"colours!
colorscheme shmibs

"enable status-line
set laststatus=2

"hide mode in cmd
set noshowmode

"allow edited background buffers
set hidden

"spelling
set spelllang=en_gb

"gvim-specific settings
set guifont=Tamsyn\ 11
set guioptions=aegimt

"visual marker for overflowing the 80th column
highlight Column80 ctermbg=black
call matchadd('Column80', '\%81v', 100)

"highlight space before tab
highlight SpaceBeforeTab ctermbg=black
call matchadd('SpaceBeforeTab', '^\ \+\t')

"highlight trailing spaces
"highlight TrailingSpace ctermbg=black
"call matchadd('TrailingSpace', '\S\s\+$')

"""""""""""""
"  ALIASES  "
"""""""""""""

"i keep accidentally typing these over and over
command W  w
command Wq wq
command WQ wq
command Q  q
command E  e


"""""""""""""""""""
"  PLUGIN THINGS  "
"""""""""""""""""""

"Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

"Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"timeout on keycodes to prevent fcitx-switcher from lagging
set ttimeoutlen=100

"vertical split ultisnips edit
let g:UltiSnipsEditSplit="vertical"

let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"


""""""""""""""
"  MAPPINGS  "
""""""""""""""

"gr is pretty useless, and gq is too cumbersome for reflow commands
noremap gr gq

"insert lines below
nnoremap ++ ==
nnoremap = Oa<C-u><Esc>j

"folds!
nnoremap fo zO
nnoremap fc zC
nnoremap fm zM
nnoremap fr zR

"buffer-handling
nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>
nnoremap <C-g> :buffers<CR>:b<Space>

"copy words from above and below the cursor
inoremap <expr> <C-y> pumvisible() ? "\<C-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')
inoremap <expr> <C-e> pumvisible() ? "\<C-e>" : matchstr(getline(line('.')+1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

"use the X clipboard for things when running in a virtual terminal, because yes
if &term != "linux" && has('clipboard')
	nnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
	nnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'
	xnoremap <expr> y (v:register ==# '"' ? '"+' : '') . 'y'
	xnoremap <expr> Y (v:register ==# '"' ? '"+' : '') . 'Y'
	
	nnoremap <expr> d (v:register ==# '"' ? '"+' : '') . 'd'
	nnoremap <expr> D (v:register ==# '"' ? '"+' : '') . 'D'
	xnoremap <expr> d (v:register ==# '"' ? '"+' : '') . 'd'
	xnoremap <expr> D (v:register ==# '"' ? '"+' : '') . 'D'
	
	nnoremap <expr> p (v:register ==# '"' ? '"+' : '') . 'p'
	nnoremap <expr> P (v:register ==# '"' ? '"+' : '') . 'P'
	xnoremap <expr> p (v:register ==# '"' ? '"+' : '') . 'p'
	xnoremap <expr> P (v:register ==# '"' ? '"+' : '') . 'P'
end


"""""""""""""""""""""""
"  FILETYPE SETTINGS  "
"""""""""""""""""""""""

"always use rust instead of hercules
au BufNewFile,BufRead *.rs set filetype=rust

"always use LaTeX
au BufNewFile,BufRead *.tex set filetype=tex

"annoying syntax-related values that need to be set before files are
"opened
let g:c_no_comment_fold = 1
let g:c_no_if0_fold = 1

"other filetype-specific settings. i can't figure out how to stick all
"the FileTypes in one dict (mostly because i have no idea what i'm
"doing with viml), so separate lines it is.
autocmd FileType asm     call Settings_asm()
autocmd FileType c       call Settings_c()
autocmd FileType cpp     call Settings_c()
autocmd FileType css     call Settings_c()
autocmd FileType tex     call Settings_tex()
autocmd FileType haskell call Settings_haskell()
autocmd FileType html    call Settings_html()
autocmd FileType xhtml   call Settings_html()
autocmd FileType make    call Settings_script()
autocmd FileType matlab  call Settings_matlab()
autocmd FileType nim     call Settings_nim()
autocmd FileType perl    call Settings_script()
autocmd FileType python  call Settings_script()
autocmd FileType ruby    call Settings_script()
autocmd FileType rust    call Settings_rust()
autocmd FileType sh      call Settings_script()
autocmd FileType text    call Settings_text()
autocmd FileType vim     call Settings_vim()
autocmd FileType zsh     call Settings_script()

function! Settings_asm()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <buffer> -- A<Tab>;<Space>
endfunction

function! Settings_c()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O<Space>*/<Esc>hhi/*<Space>
endfunction

function! Settings_haskell()
	"settings
	"mappings
	nnoremap <buffer> -- O--<Space>
endfunction

function! Settings_html()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O<Space>--><Esc>hhhi<!--<Space>
endfunction

function! Settings_matlab()
	"settings
	"mappings
	nnoremap <buffer> -- O%<Space>
endfunction

function! Settings_nim()
	call Settings_script()
	function! JumpToDef()
		if exists("*GotoDefinition_" . &filetype)
			call GotoDefinition_{&filetype}()
		else
			execute "norm! <C-]>"
		endif
	endfunction
	"mappings
	nnoremap <buffer> <M-g> :call JumpToDef()<cr>
	inoremap <buffer> <M-g> <esc>:call JumpToDef()<cr>i
	nnoremap <buffer> -_ O##<Space>
endfunction

function! Settings_script()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_rust()
	call Settings_c()
	nnoremap <buffer> -_ O///<Space>
endfunction

function! Settings_tex()
	"settings
	setlocal noautoindent
	setlocal nocindent
	setlocal nosmartindent
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O%<Space>
	nnoremap <buffer> <Leader>c :!latex -output-format=pdf "%"<CR><CR>
	nnoremap <buffer> <Leader>C :!latex -output-format=pdf "%"<CR>
endfunction

function! Settings_text()
	setlocal formatoptions+=ta
	setlocal noautoindent
	setlocal nocindent
	setlocal nosmartindent
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal spell
endfunction

function! Settings_vim()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O"
endfunction

if !has('gui_running')
	set t_Co=256
endif

""""""""""""
"  VUNDLE  "
""""""""""""

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"FILETYPES
Plugin 'kchmck/vim-coffee-script'
Plugin 'luisjure/csound'
Plugin 'elixir-lang/vim-elixir'
Plugin 'plasticboy/vim-markdown'
Plugin 'shmibs/mips.vim'
Plugin 'zah/nim.vim'
Plugin 'wlangstroth/vim-racket'
Plugin 'rust-lang/rust.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'cespare/vim-toml'

"FUNCTIONALITY
Plugin 'junegunn/vim-easy-align'

Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'

Plugin 'tommcdo/vim-exchange'

Plugin 'lilydjwg/fcitx.vim'

Plugin 'airblade/vim-gitgutter'

Plugin 'sjl/gundo.vim'

Plugin 'itchyny/lightline.vim'

Plugin 'dermusikman/sonicpi.vim'

Plugin 'tomtom/tcomment_vim'

call vundle#end()


"""""""""""""""""""""
"  PLUGIN SETTINGS  "
"""""""""""""""""""""

"Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

"Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"timeout on keycodes to prevent fcitx-switcher from lagging
set ttimeoutlen=100

"lightline colours. modded from 16color
function! s:Lightline_palette_init()
	let l:black = [ '#000000', 0 ]
	let l:lblack = [ '#808080', 8 ]
	let l:red = [ '#800000', 1 ]
	let l:lred = [ '#ff0000', 9 ]
	"let l:green = [ '#008000', 2 ]
	"let l:lgreen = [ '#00ff00', 10 ]
	let l:yellow = [ '#808000', 3 ]
	"let l:lyellow = [ '#ffff00', 11 ]
	let l:blue = [ '#000080', 4 ]
	"let l:lblue = [ '#0000ff', 12 ]
	let l:magenta = [ '#800080', 5 ]
	"let l:lmagenta = [ '#ff00ff', 13 ]
	"let l:cyan = [ '#008080', 6 ]
	"let l:lcyan = [ '#00ffff', 14 ]
	let l:white = [ '#c0c0c0', 7 ]
	let l:lwhite = [ '#ff00ff', 15 ]

	let l:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
	let l:p.normal.left = [ [ l:lwhite, l:blue ], [ l:lwhite, l:lblack ] ]
	let l:p.normal.right = [ [ l:black, l:white ], [ l:lwhite, l:lblack ] ]
	let l:p.inactive.right = [ [ l:lblack, l:black ], [ l:lblack, l:black ] ]
	let l:p.inactive.left =  [ [ l:lblack, l:black ], [ l:lblack, l:black ] ]
	let l:p.insert.left = [ [ l:lwhite, l:magenta ], [ l:lwhite, l:lblack ] ]
	let l:p.replace.left = [ [ l:lwhite, l:lred ], [ l:lwhite, l:lblack ] ]
	let l:p.visual.left = [ [ l:white, l:red ], [ l:lwhite, l:lblack ] ]
	let l:p.normal.middle = [ [ l:white, l:black ] ]
	let l:p.inactive.middle = [ [ l:white, l:black ] ]
	let l:p.tabline.left = [ [ l:white, l:black ] ]
	let l:p.tabline.tabsel = [ [ l:white, l:black ] ]
	let l:p.tabline.middle = [ [ l:black, l:white ] ]
	let l:p.tabline.right = copy(l:p.normal.right)
	let l:p.normal.error = [ [ l:white, l:red ] ]
	let l:p.normal.warning = [ [ l:white, l:yellow ] ]

	let g:lightline#colorscheme#shmibs#palette = lightline#colorscheme#flatten(l:p)
	let g:lightline = { 'colorscheme': 'shmibs' }
endfunction

call s:Lightline_palette_init()



""""""""""""""""""""""
"  GENERAL SETTINGS  "
""""""""""""""""""""""

syntax on
filetype plugin indent on
set autoindent

colorscheme shmibs

"enable status-line
set laststatus=2

"hide mode in cmd
set noshowmode

"allow edited background buffers
set hidden

set title

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

"get rid of that annoying yellow explosion everywhere
"that neovim sets as default
set nohlsearch


"""""""""""""
"  ALIASES  "
"""""""""""""

"i keep accidentally typing these over and over
command W  w
command Wq wq
command WQ wq
command Q  q
command E  e


""""""""""""""
"  MAPPINGS  "
""""""""""""""

"insert lines below
nnoremap <silent>= :set paste<CR>m`O<Esc>``:set nopaste<CR>

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

"annoying syntax-related values that need to be set before files are
"opened
let g:c_no_comment_fold = 1
let g:c_no_if0_fold = 1

let g:sh_fold_enabled = 1

if has("autocmd")
	
"always use rust instead of hercules
autocmd BufNewFile,BufRead *.rs set filetype=rust

"always use LaTeX
autocmd BufNewFile,BufRead *.tex set filetype=tex

"recognise .mips
autocmd BufNewFile,BufRead *.mips set filetype=mips

"other filetype-specific settings. i can't figure out how to stick all
"the FileTypes in one dict (mostly because i have no idea what i'm
"doing with viml), so separate lines it is.
autocmd FileType asm     call Settings_asm()
autocmd FileType bash    call Settings_script()
autocmd FileType c       call Settings_c()
autocmd FileType coffee  call Settings_coffee()
autocmd FileType conf    call Settings_conf()
autocmd FileType cpp     call Settings_c()
autocmd FileType css     call Settings_css()
autocmd FileType d       call Settings_c()
autocmd FileType elixir  call Settings_elixir()
autocmd FileType tex     call Settings_tex()
autocmd FileType haskell call Settings_haskell()
autocmd FileType html    call Settings_html()
autocmd FileType xhtml   call Settings_html()
autocmd FileType make    call Settings_script()
autocmd FileType matlab  call Settings_matlab()
autocmd FileType mips    call Settings_mips()
autocmd FileType mkd     call Settings_text()
autocmd FileType nim     call Settings_nim()
autocmd FileType perl    call Settings_script()
autocmd FileType php     call Settings_html()
autocmd FileType python  call Settings_script()
autocmd FileType ruby    call Settings_ruby()
autocmd FileType rust    call Settings_rust()
autocmd FileType scss    call Settings_css()
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
	"note: these mappings are in weird reverse order to avoid opening folds
	nnoremap <buffer> -- O<Space>*/<Esc>hhi/*<Space>
	inoremap {<CR> }<Esc>i{<CR><Esc>O
endfunction

function! Settings_coffee()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_conf()
	call Settings_script()
	setlocal expandtab
endfunction

function! Settings_css()
	call Settings_c()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
endfunction

function! Settings_elixir()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_haskell()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal expandtab
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
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O%<Space>
endfunction

function! Settings_mips()
	"settings
	setlocal shiftwidth=5
	setlocal tabstop=5
	setlocal softtabstop=5
	"mappings
	nnoremap <buffer> -- O#<Space>
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

function! Settings_ruby()
	call Settings_script()
	nnoremap <leader>r :execute "silent w !sonic_pi"<CR>
	nnoremap <leader>s :execute "silent !sonic_pi stop"<CR><C-l>
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
	setlocal nojoinspaces "single-space sentences
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

endif "autocmd

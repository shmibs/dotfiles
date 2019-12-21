if !has('gui_running')
	set t_Co=256
endif

set nocompatible



""""""""""""
"  VUNDLE  "
""""""""""""

exec 'set rtp+=' . split(&rtp, ',')[0] . '/bundle/Vundle.vim'
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"FILETYPES
Plugin 'kchmck/vim-coffee-script'
Plugin 'rhysd/vim-crystal'
Plugin 'elixir-lang/vim-elixir'
Plugin 'https://git.airen-no-jikken.icu/ageha/every.vim.git'
Plugin 'plasticboy/vim-markdown'
Plugin 'https://git.airen-no-jikken.icu/ageha/mips.vim.git'
Plugin 'zah/nim.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'cespare/vim-toml'
Plugin 'ziglang/zig.vim'

"FUNCTIONALITY
Plugin 'junegunn/vim-easy-align'

Plugin 'xolox/vim-misc'
Plugin 'https://git.airen-no-jikken.icu/ageha/vim-easytags.git'

Plugin 'tommcdo/vim-exchange'

Plugin 'lilydjwg/fcitx.vim'

Plugin 'airblade/vim-gitgutter'

Plugin 'junegunn/goyo.vim'

Plugin 'sjl/gundo.vim'

Plugin 'itchyny/lightline.vim'

Plugin 'tomtom/tcomment_vim'

Plugin 'SirVer/ultisnips'

Plugin 'junegunn/vader.vim'

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

"toggle gundo pane
nnoremap <Leader>g :GundoToggle<CR>

"snippet bindings
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-m>'
let g:UltiSnipsJumpBackwardTrigger='<c-,>'

"lightline colours. modded from 16color
fun! s:Lightline_palette_init()
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
	let g:lightline = {
				\ 'active': {
				\	'right': [ [ 'lineinfo' ],
				\	           [ 'percent' ],
				\	           [ 'filetype' ] ]
				\ }, 'colorscheme': 'shmibs' }
endfun

call s:Lightline_palette_init()

"async easytags
let g:easytags_async = 1
let g:easytags_always_enabled = 1

"goyo
fun! s:goyo_enter()
	set formatoptions+=a
endfun

fun! s:goyo_leave()
	set formatoptions-=a
endfun

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>w :execute "silent Goyo"<CR><C-l>


""""""""""""""""""""""
"  GENERAL SETTINGS  "
""""""""""""""""""""""

syntax on
filetype plugin indent on
set autoindent

"top-level folds only
set foldnestmax=1

colorscheme shmibs

"close modeline security hole
set nomodeline
set modelines=0

"revert annoying neovim cursor
set guicursor=i-ci-ve-r-cr-o-n-v-c-sm:block-blinkon200

"enable status-line
set laststatus=2

"hide mode in cmd
set noshowmode

"allow edited background buffers
set hidden

set title

"spelling
set spelllang=en_gb

"visual marker for overflowing the 80th column
highlight Overwide ctermbg=8
call matchadd('Overwide', '\%81v', 100)

"highlight space before tab
highlight SpaceBeforeTab ctermbg=red
call matchadd('SpaceBeforeTab', '\ \t')

"don't search highlighting
set nohlsearch

set encoding=utf-8
set fileencoding=utf-8



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
if &term != 'linux' && has('clipboard')
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
endif

"use pgup/pgdwn for command history completion (matches zsh conf)
cnoremap <PageUp> <up>
cnoremap <PageDown> <down>



"""""""""""""""""""""""
"  FILETYPE SETTINGS  "
"""""""""""""""""""""""

"annoying syntax-related values that need to be set before files are
"opened
let g:c_no_comment_fold = 1
let g:c_no_if0_fold = 1

let g:sh_fold_enabled = 1

if has('autocmd')

	"set various filetype-specific settings.
	augroup filetypesettings
		au FileType asm        call <SID>settings_asm()
		au FileType bash       call <SID>settings_shell()
		au FileType c          call <SID>settings_c()
		au FileType coffee     call <SID>settings_coffee()
		au FileType conf       call <SID>settings_conf()
		au FileType cpp        call <SID>settings_c()
		au FileType crystal    call <SID>settings_crystal()
		au FileType cs         call <SID>settings_c()
		au FileType css        call <SID>settings_css()
		au FileType d          call <SID>settings_c()
		au FileType elixir     call <SID>settings_elixir()
		au FileType javascript call <SID>settings_c()
		au FileType tex        call <SID>settings_tex()
		au FileType haskell    call <SID>settings_haskell()
		au FileType html       call <SID>settings_html()
		au FileType xhtml      call <SID>settings_html()
		au FileType ia64       call <SID>settings_ia64()
		au FileType make       call <SID>settings_script()
		au FileType mail       call <SID>settings_mail()
		au FileType markdown   call <SID>settings_markdown()
		au FileType matlab     call <SID>settings_matlab()
		au FileType mips       call <SID>settings_mips()
		au FileType mkd        call <SID>settings_text()
		au FileType nim        call <SID>settings_nim()
		au FileType ocaml      call <SID>settings_ocaml()
		au FileType perl       call <SID>settings_perl()
		au FileType php        call <SID>settings_html()
		au FileType python     call <SID>settings_script()
		au FileType ruby       call <SID>settings_script2()
		au FileType rust       call <SID>settings_rust()
		au FileType scss       call <SID>settings_css()
		au FileType sh         call <SID>settings_script()
		au FileType text       call <SID>settings_text()
		au FileType vim        call <SID>settings_vim()
		au FileType yaml       call <SID>settings_script2()
		au FileType zig        call <SID>settings_c()
		au FileType zsh        call <SID>settings_shell()
		au FileType z80        call <SID>settings_z80()
	augroup END

	"do other stuff
	augroup filetypemisc
		au FileType * call <SID>settings_skel_read()
	augroup END

endif "autocmd

"
" Settings Subroutines
" 

"command for reading filetype skeletons
fun! s:settings_skel_read()
	"is the buffer not empty?
	if line('$') != 1 || col('$') != 1
		return 1
	endif
	"is there no template?
	if filereadable(split(&rtp, ',')[0] . "/skel/" . &ft) == 0
		return 1
	endif
	exec 'silent! r ' . split(&rtp, ',')[0] . "/skel/" . &ft
	"read the date into %DATE%
	exec '%s/%DATE%/' . system("date '+%a, %B %d, %Y'|tr -d '\n'") . '/ge'
	"move cursor to %START%
	exec "silent! normal! ggJ/%START%\<CR>:s/%START%//\<CR>"
endfun

"run vader tests on the current file
fun! s:settings_sub_test_vim()
	"check first if curbuf is a file
	if @% != '' && filereadable(@%)
		let l:real = ''

		"test first for file in project test dir
		silent let l:base = systemlist('git rev-parse --show-toplevel')[0]
		if !v:shell_error
			let l:check = l:base . '/test/' . expand('%:t:r') . '.vader'
			if filereadable(l:check)
				let l:real = l:check
			endif
		endif

		"or else test for one in the same dir
		let l:check = expand('%:t:r') . '.vader'
		if l:real == '' && filereadable(l:check)
			let l:real = l:check
		endif

		"if a vader file was found, run the test
		if l:real != ''
			silent source %
			silent exec 'Vader' l:real
		endif
	endif
endfun

"
" Settings Functions
"

fun! s:settings_asm()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <buffer> -- A<Tab>;<Space>
	nnoremap <buffer> -_ O;<Space>
endfun

fun! s:settings_c()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal cinoptions=:0,(s,m1,U1
	"mappings
	"note: these mappings are in weird reverse order to avoid opening folds
	nnoremap <buffer> -- O<Space>*/<Esc>hhi/*<Space>
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfun

fun! s:settings_coffee()
	call <SID>settings_script2()
	setlocal foldmethod=syntax
	nnoremap <buffer> -_ O###<CR><C-u>###<Esc>O<C-u>
endfun

fun! s:settings_conf()
	call <SID>settings_script()
	setlocal expandtab
endfun

fun! s:settings_crystal()
	call <SID>settings_script2()
	setlocal expandtab
endfun

fun! s:settings_css()
	call <SID>settings_c()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
endfun

fun! s:settings_elixir()
	call <SID>settings_script2()
	inoremap <buffer> do<CR> end<Esc>hhido<CR><Esc>O
endfun

fun! s:settings_ia64()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <buffer> -- A<Space>*/<Esc>hhi<Tab>/*<Space>
	nnoremap <buffer> -_ O<Space>*/<Esc>hhi/*<Space>
endfun

fun! s:settings_haskell()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal expandtab
	"mappings
	nnoremap <buffer> -- O--<Space>
endfun

fun! s:settings_html()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O<Space>--><Esc>3hi<!--<Space>
endfun

fun! s:settings_markdown()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal nojoinspaces
	setlocal spell
	"mappings
	nnoremap <buffer> -- O<Space>--><Esc>3hi<!--<Space>
endfun

fun! s:settings_mail()
	"settings
	setlocal spell
	setlocal nojoinspaces
	"mappings
endfun

fun! s:settings_matlab()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O%<Space>
endfun

fun! s:settings_mips()
	"settings
	setlocal shiftwidth=6
	setlocal tabstop=6
	setlocal softtabstop=6
	"mappings
	nnoremap <buffer> -- A<Tab>#<Space>
	nnoremap <buffer> -_ O#<Space>
endfun

fun! s:settings_nim()
	call <SID>settings_script()
	nnoremap <buffer> -- O<Space>]#<Esc>hhi#[<Space>
endfun

fun! s:settings_ocaml()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O<Space>*)<Esc>hhi(*<Space>
	nnoremap <buffer> -_ A<Space>*)<Esc>hhi<Space>(*<Space>
	nnoremap <buffer> __ O<Space>*)<Esc>hhi(**<Space>
endfun

fun! s:settings_script()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O#<Space>
endfun

fun! s:settings_script2()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O#<Space>
endfun

fun! s:settings_perl()
	call <SID>settings_script()
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfun

fun! s:settings_rust()
	call <SID>settings_c()
	nnoremap <buffer> -_ O///<Space>
endfun

fun! s:settings_shell()
	call <SID>settings_script()
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfun

fun! s:settings_tex()
	"settings
	setlocal noautoindent
	setlocal nocindent
	setlocal nosmartindent
	setlocal nojoinspaces
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal spell
	"mappings
	nnoremap <buffer> -- O%<Space>
	nnoremap <buffer> <Leader>c :!latex -output-format=pdf "%"<CR><CR>
	nnoremap <buffer> <Leader>C :!latex -output-format=pdf "%"<CR>
	nnoremap <buffer> <Leader>x :!xelatex "%"<CR><CR>
	nnoremap <buffer> <Leader>X :!xelatex "%"<CR>
endfun

fun! s:settings_text()
	"settings
	setlocal noautoindent
	setlocal nocindent
	setlocal nosmartindent
	setlocal nojoinspaces
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal spell
	"mappings
endfun

fun! s:settings_vim()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O"
	nnoremap <buffer> <Leader>t :call <SID>settings_sub_test_vim()<CR>
endfun

fun! s:settings_z80()
	"settings
	setlocal shiftwidth=6
	setlocal tabstop=6
	setlocal softtabstop=6
	"mappings
	nnoremap <buffer> -- A<Tab>;<Space>
	nnoremap <buffer> -_ O;<Space>
endfun

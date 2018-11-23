if !has('gui_running')
	set t_Co=256
endif

set nocompatible
filetype off



""""""""""""
"  VUNDLE  "
""""""""""""

execute 'set rtp+=' . split(&rtp, ',')[0] . '/bundle/Vundle.vim'
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"FILETYPES
Plugin 'kchmck/vim-coffee-script'
Plugin 'rhysd/vim-crystal'
Plugin 'elixir-lang/vim-elixir'
Plugin 'plasticboy/vim-markdown'
Plugin 'shmibs/mips.vim'
Plugin 'zah/nim.vim'
Plugin 'wlangstroth/vim-racket'
Plugin 'rust-lang/rust.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'cespare/vim-toml'
Plugin 'ziglang/zig.vim'

"FUNCTIONALITY
Plugin 'junegunn/vim-easy-align'

Plugin 'xolox/vim-misc'
Plugin 'shmibs/vim-easytags'

Plugin 'tommcdo/vim-exchange'

Plugin 'lilydjwg/fcitx.vim'

Plugin 'airblade/vim-gitgutter'

Plugin 'junegunn/goyo.vim'

Plugin 'sjl/gundo.vim'

Plugin 'itchyny/lightline.vim'

Plugin 'tomtom/tcomment_vim'

Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

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
nnoremap <Leader>u :GundoToggle<CR>

"snippet bindings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-m>"
let g:UltiSnipsJumpBackwardTrigger="<c-,>"

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
	let g:lightline = {
				\ 'active': {
				\	'right': [ [ 'lineinfo' ],
				\	           [ 'percent' ],
				\	           [ 'filetype' ] ]
				\ }, 'colorscheme': 'shmibs' }
endfunction

call s:Lightline_palette_init()

"async easytags
let g:easytags_async = 1
let g:easytags_always_enabled = 1

"opam stuff
if executable("opam")
	let s:opam_share_dir = system("opam config var share")
	let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

	let s:opam_configuration = {}

	function! OpamConfOcpIndent()
		execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
	endfunction
	let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

	function! OpamConfOcpIndex()
		execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
	endfunction
	let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

	function! OpamConfMerlin()
		let l:dir = s:opam_share_dir . "/merlin/vim"
		execute "set rtp+=" . l:dir
	endfunction
	let s:opam_configuration['merlin'] = function('OpamConfMerlin')

	let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
	let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
	let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
	for tool in s:opam_packages
		" Respect package order (merlin should be after ocp-index)
		if count(s:opam_available_tools, tool) > 0
			call s:opam_configuration[tool]()
		endif
	endfor
endif


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

"get rid of that annoying yellow explosion everywhere
"that neovim sets as default
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

	"set various filetype-specific settings.
	augroup filetypesettings
		au FileType asm        call Settings_asm()
		au FileType bash       call Settings_shell()
		au FileType c          call Settings_c()
		au FileType coffee     call Settings_coffee()
		au FileType conf       call Settings_conf()
		au FileType cpp        call Settings_c()
		au FileType crystal    call Settings_crystal()
		au FileType cs         call Settings_c()
		au FileType css        call Settings_css()
		au FileType d          call Settings_c()
		au FileType elixir     call Settings_elixir()
		au FileType javascript call Settings_c()
		au FileType tex        call Settings_tex()
		au FileType haskell    call Settings_haskell()
		au FileType html       call Settings_html()
		au FileType xhtml      call Settings_html()
		au FileType ia64       call Settings_ia64()
		au FileType make       call Settings_script()
		au FileType mail       call Settings_mail()
		au FileType markdown   call Settings_markdown()
		au FileType matlab     call Settings_matlab()
		au FileType mips       call Settings_mips()
		au FileType mkd        call Settings_text()
		au FileType nim        call Settings_nim()
		au FileType ocaml      call Settings_ocaml()
		au FileType perl       call Settings_perl()
		au FileType php        call Settings_html()
		au FileType python     call Settings_script()
		au FileType ruby       call Settings_elixir ()
		au FileType rust       call Settings_rust()
		au FileType scss       call Settings_css()
		au FileType sh         call Settings_script()
		au FileType text       call Settings_text()
		au FileType vim        call Settings_vim()
		au FileType yaml       call Settings_script2()
		au FileType zig        call Settings_c()
		au FileType zsh        call Settings_shell()
		au FileType z80        call Settings_z80()
	augroup END

	"do other stuff
	augroup filetypemisc
		au FileType * call Settings_skel_read()
	augroup END

endif "autocmd

"command for reading filetype skeletons
function! Settings_skel_read()
	"is the buffer not empty?
	if line('$') != 1 || col('$') != 1
		return 1
	end
	"is there no template?
	if filereadable(split(&rtp, ',')[0] . "/skel/" . &ft) == 0
		return 1
	end
	execute 'silent! r ' . split(&rtp, ',')[0] . "/skel/" . &ft
	"read the date into %DATE%
	execute '%s/%DATE%/' . system("date '+%a, %B %d, %Y'|tr -d '\n'") . '/ge'
	"move cursor to %START%
	execute "silent! normal! ggJ/%START%\<CR>:s/%START%//\<CR>"
endfunction

"a 'writing mode' for prose-y formats
function! Settings_sub_wmodetoggle()
	if &fo =~ 'a'
		setlocal formatoptions-=a
		Goyo!
		echo 'wmode off'
	else
		setlocal formatoptions+=a
		Goyo
		echo 'wmode on'
	end
endfunction

function! Settings_asm()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <buffer> -- A<Tab>;<Space>
	nnoremap <buffer> -_ O;<Space>
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
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfunction

function! Settings_coffee()
	call Settings_script2()
	setlocal foldmethod=syntax
	nnoremap <buffer> -_ O###<CR><C-u>###<Esc>O<C-u>
endfunction

function! Settings_conf()
	call Settings_script()
	setlocal expandtab
endfunction

function! Settings_crystal()
	call Settings_script2()
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
	call Settings_script2()
	inoremap <buffer> do<CR> end<Esc>hhido<CR><Esc>O
endfunction

function! Settings_ia64()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <buffer> -- A<Space>*/<Esc>hhi<Tab>/*<Space>
	nnoremap <buffer> -_ O<Space>*/<Esc>hhi/*<Space>
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
	nnoremap <buffer> -- O<Space>--><Esc>3hi<!--<Space>
endfunction

function! Settings_markdown()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	setlocal nojoinspaces
	setlocal spell
	"mappings
	nnoremap <buffer> -- O<Space>--><Esc>3hi<!--<Space>
	nnoremap <buffer> <Leader>w :call Settings_sub_wmodetoggle()<CR>
endfunction

function! Settings_mail()
	"settings
	setlocal spell
	"mappings
	nnoremap <buffer> <Leader>w :call Settings_sub_wmodetoggle()<CR>
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
	setlocal shiftwidth=6
	setlocal tabstop=6
	setlocal softtabstop=6
	"mappings
	nnoremap <buffer> -- A<Tab>#<Space>
	nnoremap <buffer> -_ O#<Space>
endfunction

function! Settings_nim()
	call Settings_script()
	nnoremap <buffer> -- O<Space>]#<Esc>hhi#[<Space>
endfunction

function! Settings_ocaml()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O<Space>*)<Esc>hhi(**<Space>
	nnoremap <buffer> -_ A<Space>*)<Esc>hhi(*<Space>
endfunction

function! Settings_script()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_script2()
	"settings
	setlocal shiftwidth=2
	setlocal tabstop=2
	setlocal softtabstop=2
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_perl()
	call Settings_script()
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfunction

function! Settings_rust()
	call Settings_c()
	nnoremap <buffer> -_ O///<Space>
endfunction

function! Settings_shell()
	call Settings_script()
	inoremap <buffer> {<CR> }<Esc>i{<CR><Esc>O
endfunction

function! Settings_tex()
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
	nnoremap <buffer> <Leader>w :call Settings_sub_wmodetoggle()<CR>
endfunction

function! Settings_text()
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
	nnoremap <buffer> <Leader>w :call Settings_sub_wmodetoggle()<CR>
endfunction

function! Settings_vim()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
	"mappings
	nnoremap <buffer> -- O"
endfunction

function! Settings_z80()
	"settings
	setlocal shiftwidth=6
	setlocal tabstop=6
	setlocal softtabstop=6
	"mappings
	nnoremap <buffer> -- A<Tab>;<Space>
	nnoremap <buffer> -_ O;<Space>
endfunction

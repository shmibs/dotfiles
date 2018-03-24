if !has('gui_running')
	set t_Co=256
endif

""""""""""""
"  VUNDLE  "
""""""""""""

set nocompatible
filetype off

execute 'set rtp+=' . split(&rtp, ',')[0] . '/bundle/Vundle.vim'
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"FILETYPES
Plugin 'kchmck/vim-coffee-script'
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



""""""""""""""""""""""
"  GENERAL SETTINGS  "
""""""""""""""""""""""

syntax on
filetype plugin indent on
set autoindent

colorscheme shmibs

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
	
"always use rust instead of hercules
autocmd BufNewFile,BufRead *.rs set filetype=rust

"always use LaTeX
autocmd BufNewFile,BufRead *.tex set filetype=tex

"recognise .mips
autocmd BufNewFile,BufRead *.mips set filetype=mips

"other filetype-specific settings. i can't figure out how to stick all
"the FileTypes in one dict (mostly because i have no idea what i'm
"doing with viml), so separate lines it is.
autocmd FileType asm        call Settings_asm()
autocmd FileType bash       call Settings_shell()
autocmd FileType c          call Settings_c()
autocmd FileType coffee     call Settings_coffee()
autocmd FileType conf       call Settings_conf()
autocmd FileType cpp        call Settings_c()
autocmd FileType css        call Settings_css()
autocmd FileType d          call Settings_c()
autocmd FileType elixir     call Settings_elixir()
autocmd FileType javascript call Settings_c()
autocmd FileType tex        call Settings_tex()
autocmd FileType haskell    call Settings_haskell()
autocmd FileType html       call Settings_html()
autocmd FileType xhtml      call Settings_html()
autocmd FileType make       call Settings_script()
autocmd FileType mail       call Settings_mail()
autocmd FileType markdown   call Settings_markdown()
autocmd FileType matlab     call Settings_matlab()
autocmd FileType mips       call Settings_mips()
autocmd FileType nim        call Settings_nim()
autocmd FileType mkd        call Settings_text()
autocmd FileType perl       call Settings_perl()
autocmd FileType php        call Settings_html()
autocmd FileType python     call Settings_script()
autocmd FileType ruby       call Settings_script()
autocmd FileType rust       call Settings_rust()
autocmd FileType scss       call Settings_css()
autocmd FileType sh         call Settings_script()
autocmd FileType text       call Settings_text()
autocmd FileType vim        call Settings_vim()
autocmd FileType zsh        call Settings_shell()

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
autocmd FileType * call Settings_skel_read()

""write mode" for prose-y formats
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
	inoremap <buffer> do<CR> end<Esc>hhido<CR><Esc>O
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
	setlocal shiftwidth=5
	setlocal tabstop=5
	setlocal softtabstop=5
	"mappings
	nnoremap <buffer> -- O#<Space>
endfunction

function! Settings_nim()
	call Settings_script()
	nnoremap <buffer> -- O<Space>]#<Esc>hhi#[<Space>
endfunction

function! Settings_script()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	setlocal softtabstop=4
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

endif "autocmd

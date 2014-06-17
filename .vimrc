syntax on
filetype plugin on
"set omnifunc=syntaxcomplete#Complete
set autoindent

"colours!
colorscheme anotherdark
set background=dark

"enable status-line
set laststatus=2

"hide mode in cmd
set noshowmode

"allow edited background buffers
set hidden

"vim-latex settings
set grepprg=grep\ -nH\ $*
let g:tex_flavor="latex"

"gvim-specific settings
set guifont=Tamsyn\ 11
set guioptions=aegimt

"buffer controls to match pentadactyl
noremap <C-n> <Esc>:bn<CR>
noremap <C-p> <Esc>:bp<CR>
noremap <C-t> <Esc>:badd<Space>
noremap <C-g> <Esc>:buffers<CR>:b<Space>

"insert lines above and below with (=|+)
"very hackish, but i couldn't think of a better way
nnoremap = Oa<C-u><Esc>j
nnoremap + oa<C-u><Esc>k

"folds!
nnoremap fo zO
nnoremap fc zC
nnoremap fm zM
nnoremap fr zR

"copy words from above and below the cursor
inoremap <expr> <C-y> pumvisible() ? "\<C-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')
inoremap <expr> <C-e> pumvisible() ? "\<C-e>" : matchstr(getline(line('.')+1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

"use the X clipboard for things when running in a virtual terminal, because yes
if &term != "linux"
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

"annoying syntax-related values that need to be set before files are
"opened
let g:c_no_comment_fold = 1
let g:c_no_if0_fold = 1

"other filetype-specific settings. i can't figure out how to stick all
"the FileTypes in one list (mostly because i have no idea what i'm
"doing with viml), so separate lines it is.
autocmd FileType asm     call Settings_asm()
autocmd FileType c       call Settings_c()
autocmd FileType cpp     call Settings_c()
autocmd FileType haskell call Settings_haskell()
autocmd FileType make    call Settings_script()
autocmd FileType perl    call Settings_script()
autocmd FileType python  call Settings_script()
autocmd FileType sh      call Settings_script()
autocmd FileType vim     call Settings_vim()

function! Settings_asm()
	setlocal cindent
	set foldmethod=syntax
	noremap -- A<Tab>;<Space>
endfunction

function! Settings_c()
	setlocal cindent
	set foldmethod=syntax
	noremap -- A<Space>/*<Space><Space>*/<Esc>hhi
endfunction

function! Settings_haskell()
	setlocal smartindent
	noremap -- A<Space>--<Space>
endfunction

function! Settings_script()
	setlocal smartindent
	noremap -- A<Space>#<Space>
endfunction

function! Settings_vim()
	setlocal smartindent
	noremap -- A<Space>"
endfunction

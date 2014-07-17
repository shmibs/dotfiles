syntax on
filetype plugin indent on
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

"gvim-specific settings
set guifont=Tamsyn\ 11
set guioptions=aegimt

"buffer / tab controls
nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>
nnoremap <C-g> :buffers<CR>:b<Space>
nnoremap <C-n> :tabn<CR>
nnoremap <C-p> :tabp<CR>
nnoremap <C-t> <C-w>s<C-w>T
nnoremap <C-w><C-n> :tabm +1<CR>
nnoremap <C-w><C-p> :tabm -1<CR>

"insert lines below
nnoremap ++ ==
nnoremap = Oa<C-u><Esc>j

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
autocmd FileType cpp     call Settings_cpp()
autocmd FileType tex     call Settings_tex()
autocmd FileType haskell call Settings_haskell()
autocmd FileType make    call Settings_script()
autocmd FileType matlab  call Settings_matlab()
autocmd FileType perl    call Settings_script()
autocmd FileType python  call Settings_script()
autocmd FileType sh      call Settings_script()
autocmd FileType vim     call Settings_vim()
autocmd FileType zsh     call Settings_script()

function! Settings_asm()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap -- A<Tab>;<Space>
endfunction

function! Settings_c()
	"settings
	setlocal foldmethod=syntax
	"mappings
	nnoremap <Leader>c :!make<CR>
	nnoremap -- O<Space>*/<Esc>hhi/*<Space>
endfunction

function! Settings_cpp()
	"settings
	setlocal foldmethod=syntax
	setlocal shiftwidth=4
	setlocal tabstop=4
	"mappings
	nnoremap <Leader>c :!make<CR>
	nnoremap -- O<Space>*/<Esc>hhi/*<Space>
endfunction

function! Settings_haskell()
	"settings
	"mappings
	nnoremap -- O--<Space>
endfunction

function! Settings_matlab()
	"settings
	"mappings
	nnoremap -- O%<Space>
endfunction

function! Settings_script()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	"mappings
	nnoremap -- O#<Space>
endfunction

function! Settings_tex()
	"settings
	setlocal shiftwidth=4
	setlocal tabstop=4
	"mappings
	nnoremap -- O%<Space>
	nnoremap <Leader>c :!latex -output-format=pdf %<CR><CR>
	nnoremap <Leader>C :!latex -output-format=pdf %<CR>
endfunction

function! Settings_vim()
	"settings
	"mappings
	nnoremap -- O"
endfunction

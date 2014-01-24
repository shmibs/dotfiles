syntax on
filetype plugin on
set autoindent

"tab controls to match pentadactyl
map <C-n> <Esc>:tabn<CR>
map <C-p> <Esc>:tabp<CR>
map <C-t> <Esc>:tabnew<CR>

"insert lines above and below with (=|+)
nnoremap = O<Esc>j
nnoremap + O<Esc>

"copy words from above and below the cursor
inoremap <expr> <c-y> pumvisible() ? "\<c-y>" : matchstr(getline(line('.')-1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')
inoremap <expr> <c-e> pumvisible() ? "\<c-e>" : matchstr(getline(line('.')+1), '\%' . virtcol('.') . 'v\%(\k\+\\|.\)')

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

"filetype-specific settings. i can't figure out how to stick all the
"FileTypes in one list (mostly because i have no idea what i'm doing
"with viml), so separate lines it is.
autocmd FileType c   call Settings_c()
autocmd FileType cpp call Settings_c()

function! Settings_c()
	"i want autoindent as the default, and doing that along with
	"filetype indent on yields wonky results
	setlocal cindent
endfunction


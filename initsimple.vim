call plug#begin('~/.vim/plugged')
Plug '907th/vim-auto-save'    
Plug 'tomasiser/vim-code-dark'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
call plug#end() 

autocmd VimEnter *
  \  if len(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

filetype on    
filetype plugin off    
filetype indent on 
let g:AutoPairFlyMode = 0
        
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif        
              
set tabstop=2    
set shiftwidth=2    
set softtabstop=2    
set smarttab    
set expandtab    
set autoindent    
set number
set relativenumber    
set cursorline
set cursorcolumn
set laststatus=2    
set splitright    
set mouse=a 

set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes

let mapleader = ","

inoremap tt <Esc> 
nnoremap L <C-W><C-W>    
nnoremap H <C-W><C-H>
nnoremap O :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap P :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>
tnoremap dk <C-\><C-N><C-W><C-W> 

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
" inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
        
map fd :tabnew
map Q :qa<CR>    
map W :Vex<CR>       
map z <C-f>    
map x <C-b>    
" map B :vs<Bar>:term<CR>L<Bar>:vertical resize 105<CR>  
" map B :vs<Bar>:term<CR>
map ss ZZ    
map F :vertical resize 105<CR> 
map M <C-z>        
map S :s/ <left>    
map vn :vs 
" map bn :bd<CR>
map E :tabp<CR>
map T :tabn<CR>
    
let g:netrw_banner = 0    
let g:netrw_liststyle = 3    
let g:netrw_browse_split = 4    
let g:netrw_winsize = 25    
let g:netrw_altv = 1    
let g:auto_save = 1    
let g:auto_save_silent = 1    
let g:auto_save_events = ["InsertLeave","TextChanged","TextChangedI"]    
let g:tsuquyomi_disable_quickfix = 1  

colorscheme codedark
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi CursorColumn cterm=NONE 
hi CursorLine ctermbg=NONE
hi Pmenu guifg=NONE ctermbg=NONE
hi TablineFill ctermbg=NONE
hi StatusLine ctermbg=NONE cterm=NONE

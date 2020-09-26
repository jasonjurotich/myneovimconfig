call plug#begin('~/.vim/plugged')
Plug '907th/vim-auto-save'    
Plug 'itchyny/lightline.vim'    
Plug 'tomasiser/vim-code-dark'    
Plug 'Quramy/tsuquyomi'    
Plug 'rust-lang/rust.vim'    
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

"Plug 'jiangmiao/auto-pairs' 
"Plug 'tpope/vim-surround'
"Plug 'tomtom/tcomment_vim'                                                                                                   
"Plug 'vim-scripts/ReplaceWithRegister'

call plug#end() 

autocmd VimEnter *
  \  if len(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

filetype on    
filetype plugin off    
filetype indent on    
        
set noshowmode    
set tabstop=2    
set shiftwidth=2    
set softtabstop=2    
set smarttab    
set expandtab    
set autoindent    
set number
set relativenumber    
set cursorline    
set laststatus=2    
set splitright    
set mouse=a 
" set winblend=15

inoremap ff <Esc> 
nnoremap L <C-W><C-W>    
nnoremap H <C-W><C-H>    
tnoremap dk <C-\><C-N><C-W><C-W>          
      
map ft :bprev<CR>    
map fe :bnext<CR>    
map fd :tabnew 
map te :tabclose
map Q :qa<CR>    
map W :Vex<CR>    
map E <C-d>    
map R <C-u>    
map z <C-f>    
map x <C-b>    
map B :vnew term://bash<CR>    
" map K :below new<CR>:terminal<CR>
map ss ZZ    
map F :vert res 50<CR>    
map M <C-z>    
map S :s///g<left><left><left>    
map R :%s///g<left><left><left>    
map vb :vs    
    
let g:netrw_banner = 0    
let g:netrw_liststyle = 3    
let g:netrw_browse_split = 4    
let g:netrw_winsize = 25    
let g:netrw_altv = 1    
let g:auto_save = 1    
let g:auto_save_silent = 1    
let g:auto_save_events = ["InsertLeave","TextChanged","TextChangedI"]    
let g:tsuquyomi_disable_quickfix = 1  


" COC CONFIG BEGIN

set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

function! CocCurrentFunction()    
  return get(b:, 'coc_current_function', '')    
endfunction    
      
let g:lightline = {    
  \ 'colorscheme': 'wombat',    
  \ 'active': {    
  \ 'left': [ [ 'mode', 'paste' ],    
  \ [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]    
  \ },    
  \ 'component_function': {    
  \ 'cocstatus': 'coc#status',    
  \ 'currentfunction': 'CocCurrentFunction'    
  \ },
  \ }

let g:coc_global_extensions = ["coc-css",
  \ "coc-eslint",
  \ "coc-html",
  \ "coc-json",
  \ "coc-prettier",
  \ "coc-python",
  \ "coc-tslint",
  \ "coc-tsserver",
  \ "coc-ultisnips",
  \ "coc-tailwindcss",
  \ "coc-vetur",
  \ "coc-rust-analyzer",
  \ "coc-pairs"]

" COC CONFIG END


colorscheme codedark
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
" hi CursorLine ctermbg=NONE
" hi Pmenu guifg=NONE ctermbg=NONE

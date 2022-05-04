call plug#begin('~/.vim/plugged')
Plug '907th/vim-auto-save' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tomasiser/vim-code-dark'    
Plug 'preservim/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'alvan/vim-closetag'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/vim-vsnip'

Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'rust-lang/rust.vim' 

call plug#end() 

autocmd VimEnter *
  \  if len(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

filetype on    
filetype plugin off    
filetype indent on    

if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

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
set cursorcolumn
set laststatus=2    
set splitright    
set mouse=a 
" set winblend=15

set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=yes

set completeopt=menuone,noinsert,noselect
set shortmess+=c

let mapleader = ","

inoremap tt <Esc> 
nnoremap L <C-W><C-W>    
nnoremap H <C-W><C-H>
nnoremap O :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>
nnoremap P :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
tnoremap dk <C-\><C-N><C-W><C-W>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
      
" map ft :bprev<CR>    
" map fe :bnext<CR>    
map fd :tabnew 
map re :tabclose
map Q :qa<CR>    
map W :Vex<CR>       
map z <C-f>    
map x <C-b>    
map B :vs<Bar>:term<CR>L<Bar>:vertical resize 105<CR>   
" map K :below new<CR>:terminal<CR>
map ss ZZ    
map F :vertical resize 105<CR> 
map M <C-z>    
map R :s///g<left><left><left>    
map S :%s///gI<left><left><left>    
map vb :vs  

map <leader>g :NERDTree<CR>

    
let g:netrw_banner = 0    
let g:netrw_liststyle = 3    
let g:netrw_browse_split = 4    
let g:netrw_winsize = 25    
let g:netrw_altv = 1    
let g:auto_save = 1    
let g:auto_save_silent = 1    
let g:auto_save_events = ["InsertLeave","TextChanged","TextChangedI"]    
let g:tsuquyomi_disable_quickfix = 1  

" LSP CONFIG BEGIN
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)

lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { 
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

" LSP CONFIG END

let g:airline_theme='base16'

" AIRLINE START


" AIRLINE END

colorscheme codedark
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi CursorLine ctermbg=NONE
" hi CursorColumn ctermbg=NONE 
hi Pmenu guifg=NONE ctermbg=NONE

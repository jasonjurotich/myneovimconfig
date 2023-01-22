---------------------
-- packer
---------------------

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- you can use lazy git to configure everything if something breaks in the future
-- https://github.com/vonheikemen/lsp-zero.nvim/blob/main/advance-usage.md
require("packer").startup(function(use)
  use("wbthomason/packer.nvim")
  use("nvim-lua/plenary.nvim")

  -- color
  use("mofiqul/vscode.nvim")

  -- writing
  use("junegunn/goyo.vim")
  use("preservim/vim-pencil")
  use("junegunn/limelight.vim")

  -- auto save
  use("pocco81/auto-save.nvim")

  -- time worked
  use("wakatime/vim-wakatime")

  -- format
  use("tpope/vim-surround")
  use("p00f/nvim-ts-rainbow")
  use("windwp/nvim-autopairs")
  use("akinsho/toggleterm.nvim")
  use("nvim-lualine/lualine.nvim")
  use("numtostr/comment.nvim")
  use("lukas-reineke/indent-blankline.nvim")
  use("moll/vim-bbye")
  use("szw/vim-maximizer")

  -- nvim tree
  use("nvim-tree/nvim-tree.lua")
  use("nvim-tree/nvim-web-devicons")

  -- autocompletion, must be before lsp
  use("hrsh7th/nvim-cmp") -- required
  use("hrsh7th/cmp-nvim-lsp") -- required
  use("hrsh7th/cmp-buffer") -- optional
  use("hrsh7th/cmp-path") -- optional
  use("saadparwaiz1/cmp_luasnip") -- optional
  use("hrsh7th/cmp-nvim-lua") -- optional
  use("onsails/lspkind.nvim")

  -- snippets
  use("l3mon4d3/luasnip") -- required
  use("rafamadriz/friendly-snippets") -- optional

  -- install lsp package manager, must be before lsp
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")

  -- null ls for formatting and linting
  use("jayp0521/mason-null-ls.nvim")
  use("jose-elias-alvarez/null-ls.nvim")

  -- lsp
  use("neovim/nvim-lspconfig")
  use("simrat39/rust-tools.nvim")

  -- dap
  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  use("thehamsta/nvim-dap-virtual-text")

  -- bufferline
  use({
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    requires = "nvim-tree/nvim-web-devicons",
  })

  -- treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  })

  use({
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
  })

  -- telescope
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })

  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cond = vim.fn.executable("make") == 1,
  })

  -- formating and linting with null
  use("jose-elias-alvarez/null-ls.nvim")

  -- git
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  })

  -- tab nine
  use({
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  })

  -- postgres
  use({
    "kristijanhusak/vim-dadbod-ui",
    requires = {
      "tpope/vim-dadbod",
      "tpope/vim-dotenv",
      "kristijanhusak/vim-dadbod-completion",
    },
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)

---------------------
-- options
---------------------
vim.g.rust_recommended_style = 0
vim.opt.ls = 0
vim.opt.ch = 0

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.list = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.wrap = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"

vim.opt.cursorline = false
vim.opt.signcolumn = "yes"

vim.opt.termguicolors = true
-- vim.opt.background = "dark"
-- you cannot put spaces after commas in lua, causes an error
vim.opt.backspace = "indent,eol,start"

-- see if this causes conflict with tmux
vim.opt.clipboard:append("unnamedplus")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars = "eob: "

-- this allows the dash to be part of a word like a normal letter
vim.opt.iskeyword:append("-")

vim.opt.shortmess:append("c")

vim.opt.completeopt = "menu,menuone,noselect,noinsert"

-- do not erase, info for spelling!
-- vim.opt.spell = true
-- https://github.com/neovim/neovim/blob/master/runtime/autoload/spellfile.vim
-- for neovim you have to first create the folder .config/nvim/spell
-- then you have to download es.utf-8.spl from https://ftp.nluug.nl/vim/runtime/spell/
-- then you put that file in the new folder.

vim.g.spellfile_url = "https://ftp.nluug.nl/vim/runtime/spell/"
vim.g.loaded_spellfile_plugin = 0
vim.opt.spelllang = { "en_us", "es_mx" }
vim.api.nvim_create_autocmd("filetype", {
  pattern = { "html", "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
-- vim.cmd([[autocmd filetype markdown setlocal spell]])
-- vim.cmd([[autocmd filetype markdown setlocal complete+=kspell]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
-- vim.g.nvim_tree_width = 25

vim.cmd([[inoremap ww println!("{:#?}",);<left><left>]])
vim.cmd([[autocmd bufwritepre * lua vim.lsp.buf.format()]])

vim.cmd([[colorscheme vscode]])
vim.diagnostic.config({ virtual_text = false })

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_win_position = "left"
vim.g.db_ui_winwidth = 25

vim.g.db_ui_icons = {
  expanded = {
    db = "▾ ",
    buffers = "▾ ",
    saved_queries = "▾ ",
    schemas = "▾ ",
    schema = "▾ פּ",
    tables = "▾ 藺",
    table = "▾ ",
  },
  collapsed = {
    db = "▸ ",
    buffers = "▸ ",
    saved_queries = "▸ ",
    schemas = "▸ ",
    schema = "▸ פּ",
    tables = "▸ 藺",
    table = "▸ ",
  },
  saved_query = "",
  new_query = "璘",
  tables = "離",
  buffers = "﬘",
  add_connection = "",
  connection_ok = "✓",
  connection_error = "✕",
}

vim.g.db_ui_table_helpers = {
  postgres = {
    count = "select count(*) from {table}",
    list = "select * from {table} order by id asc",
  },
  sqlite = {
    describe = "pragma table_info({table})",
  },
}

vim.g.db_ui_auto_execute_table_helpers = 1

-- put postgres info here
vim.g.dbs = {

  dev = "postgres://postgres:mypassword@localhost:5432/my-dev-db",
}
vim.g.db_ui_save_location = "~/documents/rustdev/postgrs"

-- set leader key to space
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

---------------------
-- general keymaps
---------------------
local opts = { noremap = true, silent = true }
keymap.set("i", "tt", "<ESC>")
keymap.set("t", "J", "<C-\\><C-N><C-W><C-W>")
keymap.set("t", "kj", "<C-\\><C-N>")
keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>")
keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>")

keymap.set("n", "Q", ":x<CR>")
keymap.set("n", "W", ":x<CR>:x<CR>")
keymap.set("n", "L", "<C-W><C-W>")
keymap.set("n", "H", "<C-W><C-H>")
keymap.set("n", "gb", "<C-o>")
keymap.set("n", "ss", "ZZ")
keymap.set("n", "vs", ":vs<CR>")
keymap.set("n", "te", ":ToggleTerm size=80 dir direction=vertical hidden=true <CR>")
keymap.set("n", "<Tab>", ":bnext<CR>", opts)
keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
keymap.set("n", "<leader>db", ":w<CR>:Bdelete!<CR>")
keymap.set("n", "gv", ":lua vim.lsp.buf.format()<CR>")
keymap.set("n", "z", "<C-f>")
keymap.set("n", "x", "<C-b>")
keymap.set("n", "<leader>w", ":w<CR>")
keymap.set("n", "<leader>5", "g_")
keymap.set("n", "<leader>r", ":res +20<CR>")

keymap.set("n", "<S-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<S-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<S-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- window management
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tu", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab
keymap.set("n", "<leader>dt", ":tab DBUI<cr>", {})
keymap.set("n", "<leader>du", ":tabclose<CR>:bnext<CR>:Bdelete!<CR><C-W><C-W>ZZ", {})

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>") -- find files within github folder
keymap.set("n", "<leader>fp", "<cmd>Telescope find_files cwd=~/<cr>") -- find files within root directory
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope diagnostics<CR>", opts)

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>go", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- nvim-tree
keymap.set("n", "<leader>e", ":nvimtreetoggle<cr>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fg", "<cmd>telescope git_files<cr>") -- find files within github folder
keymap.set("n", "<leader>fp", "<cmd>telescope find_files cwd=~/<cr>") -- find files within root directory
keymap.set("n", "<leader>fs", "<cmd>telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>telescope diagnostics<cr>", opts)

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>go", "<cmd>telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":lsprestart<cr>") -- mapping to restart lsp if necessary

-- vim-maximizer
keymap.set("n", "<leader>sm", ":maximizertoggle<cr>") -- toggle split window maximization

-- goyo
keymap.set("n", "<leader>gy", ":goyo 80<cr>") -- mapping to restart lsp if necessary

-- spelling
vim.keymap.set("n", "<leader>s", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end, { desc = "spelling suggestions" })

---------------------
-- requirements
---------------------

-- for color put all after this
require("vscode").setup({
  transparent = true,
  italic_comments = true,
  disable_nvimtree_bg = true,
  group_overrides = {
    bufferlinefill = { fg = "none" },
  },
})

local custom_vscode = require("lualine.themes.vscode")
custom_vscode.normal.c.bg = "none"
custom_vscode.insert.c.bg = "none"
custom_vscode.command.c.bg = "none"
require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = custom_vscode,
    component_separators = "|",
    section_separators = "",
    path = 2,
  },
})

vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
vim.api.nvim_set_hl(0, "floatborder", { bg = "none", fg = "#464140" })

-- vim.cmd([[hi normal guibg=none ctermbg=none]])
-- vim.cmd([[hi normalnc guibg=none ctermbg=none]])

-- end for color

-- format for text
require("comment").setup({
  toggler = {
    line = "gcc",
    block = "x,c",
  },
  opleader = {
    line = "gc",
    block = "x,",
  },
})

require("indent_blankline").setup({
  buftype_exclude = { "terminal" },
  filetype_exclude = { "dashboard", "packer" },
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  show_end_of_line = false,
})

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})

require("auto-save").setup({
  enabled = true,
  trigger_events = { "insertleave" },
  write_all_buffers = false,
})

require("bufferline").setup({
  options = {
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "bdelete! %d", -- can be a string | function, see "mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "mouse actions"
    indicator_icon = nil,
    indicator = { style = "icon", icon = "▎" },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 30,
    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
    tab_size = 21,
    diagnostics = true, -- | "nvim_lsp" | "coc",
    diagnostics_update_in_insert = true,
    -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
    -- 	return "(" .. count .. ")"
    -- end,
    offsets = { { filetype = "nvimtree", text = "", padding = 1 } },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  },
  highlights = {
    buffer_selected = {
      bold = true,
      italic = true,
      underline = false,
      fg = "yellow",
      -- bg = "white",
    },
  },
})

-- https://github.com/pocco81/true-zen.nvim
-- https://github.com/junegunn/limelight.vim/issues/7
local augroup2 = vim.api.nvim_create_augroup("goyo_cmds", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

vim.g.goyo_height = "100%"
-- vim.g.limelight_conceal_ctermfg = 800
vim.g.limelight_conceal_guifg = "#808080"
vim.g.limelight_default_coefficient = 0.1
vim.g.limelight_priority = -1
vim.g.limelight_paragraph_span = 0

local enter = function()
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.cmd("limelight")
end

local leave = function()
  vim.opt.wrap = false
  vim.opt.linebreak = false
  vim.cmd("limelight!")
end

autocmd("user", { pattern = "goyoenter", group = augroup2, callback = enter })
autocmd("user", { pattern = "goyoleave", group = augroup2, callback = leave })

-- end of format

-- telescope
local tel = require("telescope")
local actions = require("telescope.actions")
tel.setup({
  defaults = {
    mappings = {
      i = {
        ["<leader>q"] = actions.close, -- move to prev result
        ["<leader>v"] = actions.select_vertical, -- open vertically
        ["<leader>e"] = actions.preview_scrolling_up, -- move to prev result
        ["<leader>d"] = actions.preview_scrolling_down, -- move to prev result
        ["<s-tab>"] = actions.move_selection_previous, -- move to prev result
        ["<tab>"] = actions.move_selection_next, -- move to next result
        ["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
      },
    },
  },
})

-- toggle term
require("toggleterm").setup({
  size = 80,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = false,
  shading_factor = 1,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  persist_mode = false,
  close_on_exit = true,
  direction = "vertical",
  shell = vim.o.shell,
})

local Terminal = require("toggleterm.terminal").Terminal

-- spotify
local spotify = Terminal:new({ cmd = "spt", hidden = true, direction = "float" })
function _spotify()
  spotify:toggle()
end

vim.api.nvim_set_keymap("n", "sp", "<cmd>lua _spotify()<cr>", { noremap = true, silent = true })

-- bottom
local bottom = Terminal:new({ cmd = "btm", hidden = true, direction = "float" })
function _bottom()
  bottom:toggle()
end

vim.api.nvim_set_keymap("n", "mb", "<cmd>lua _bottom()<cr>", { noremap = true, silent = true })

-- lsp installers, this only installs these, it does nothing else.
-- https://github.com/williamboman/mason.nvim
-- mason must come before lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "sumneko_lua",
    "emmet_ls",
    "rust_analyzer",
    "texlab",
    "jsonls",
    "marksman",
    "taplo",
    "ltex",
  },
  automatic_installation = true,
})

-- null ls for formatting and linting
require("mason-null-ls").setup({
  ensure_installed = {
    "prettier", -- ts/js formatter
    "stylua", -- lua formatter
    "eslint_d",
    "markdownlint",
    "cspell",
  },
  automatic_installation = true,
})

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

local augroup = vim.api.nvim_create_augroup("lspformatting", {})
null_ls.setup({
  sources = {
    formatting.rustfmt, -- rust formatter
    formatting.prettier, -- js/ts formatter
    formatting.stylua, -- lua formatter
    formatting.markdownlint,
    diagnostics.eslint_d.with({
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js")
      end,
    }),
  },

  -- configure format on save
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textdocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("bufwritepre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end,
})

-- end of formatting and linting

-- postgres
local dbss = Terminal:new({
  cmd = "nvim -c :dbui",
  hidden = true,
  direction = "float",
})

function _dbss()
  dbss:toggle()
end

vim.api.nvim_set_keymap("n", "sn", "<cmd>lua _dbss()<cr>", { noremap = true, silent = true })
-- end of postgres

-- treesitter
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  -- enable indentation
  indent = { enable = false, disable = { "rust" } },
  -- enable autotagging (w/ nvim-ts-autotag plugin)
  autotag = { enable = true },
  -- ensure these language parsers are installed
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "markdown",
    "svelte",
    "graphql",
    "bash",
    "lua",
    "vim",
    "dockerfile",
    "gitignore",
    "rust",
    "latex",
  },
  -- auto install above language parsers
  auto_install = true,
  additional_vim_regex_highlighting = false,
})

require("nvim-treesitter.configs").setup({
  autotag = {
    enable = true,
  },
})

require("nvim-autopairs").setup({
  check_ts = true, -- enable treesitter
  ts_config = {
    lua = { "string" },
    javascript = { "template_string" },
    java = false,
  },
  condition = function()
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
})

------------------
-- lsp
------------------

-- cmp
local tabnine = require("cmp_tabnine.config")

tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
  show_prediction_strength = true,
})

local luasnip = require("luasnip")
local lspkind = require("lspkind")

local source_mapping = {
  buffer = "[buffer]",
  path = "[path]",
  nvim_lsp = "[lsp]",
  nvim_lua = "[lua]",
  cmp_tabnine = "[tn]",
  spell = "[sp]",
  ["vim-dadbod-completion"] = "[db]",
}

require("luasnip/loaders/from_vscode").lazy_load()
local cmp = require("cmp")
cmp.setup({

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<S-tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
    ["<Tab>"] = cmp.mapping.select_next_item(), -- next suggestion
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  }),

  window = {
    completion = cmp.config.window.bordered({
      scrollbar = false,
      -- https://www.youtube.com/watch?v=wcvcfozotbm
      -- https://www.youtube.com/watch?v=udpz2yjs6os
      -- https://github.com/hrsh7th/nvim-cmp/issues/671
      border = "rounded",
      winhighlight = "normal:mynormal,floatborder:myfloatborder,cursorline:mycursorline,search:none",
    }),
    documentation = cmp.config.window.bordered({
      scrollbar = false,
      border = "rounded",
      winhighlight = "normal:mynormal,floatborder:myfloatborder,cursorline:mycursorline,search:none",
    }),
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- lsp
    { name = "luasnip" }, -- snippets
    { name = "buffer" }, -- text within current buffer
    { name = "path" }, -- file system paths
    { name = "cmp_tabnine" },
    { name = "lua-latex-symbols", option = { cache = true } },
    {
      name = "spell",
      option = {
        keep_all_entries = true,
        enable_in_context = function()
          return true
        end,
      },
    },
  }),

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
      vim_item.menu = source_mapping[entry.source.name]
      if entry.source.name == "cmp_tabnine" then
        local detail = (entry.completion_item.data or {}).detail
        vim_item.kind = ""
        if detail and detail:find(".*%%.*") then
          vim_item.kind = vim_item.kind .. " " .. detail
        end

        if (entry.completion_item.data or {}).multiline then
          vim_item.kind = vim_item.kind .. " " .. "[ml]"
        end
      end
      local maxwidth = 80
      vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
      return vim_item
    end,
  },
})

vim.api.nvim_set_hl(0, "mynormal", { bg = "none", fg = "white" })
vim.api.nvim_set_hl(0, "myfloatborder", { bg = "none", fg = "#464140" })
vim.api.nvim_set_hl(0, "mycursorline", { bg = "#837674", fg = "white" })

-- lspconfig
local on_attach = function(client, bufnr)
  local opts1 = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.show_line_diagnostics<cr>", opts1) -- show  diagnostics for line
  vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<cr>", opts1)
  vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.show_cursor_diagnostics<cr>", opts1) -- show diagnostics for cursor
  vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts1) -- jump to previous diagnostic in buffer
  vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts1) -- jump to next diagnostic in buffer

  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.peek_definition<cr>", opts1) -- see definition and make edits in window
  vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.lsp_finder<cr>", opts1) -- show definition, references
  vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts1) -- smart rename
  vim.keymap.set("n", "k", "<cmd>lua vim.lsp.buf.hover()<cr>", opts1) -- show documentation for what is under cursor
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts1) -- got to declaration
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts1) -- go to implementation
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts1) -- go to references
  vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action<cr>", opts1) -- see available code actions
  vim.keymap.set("n", "<leader>o", "<cmd>lsoutlinetoggle<cr>", opts1) -- see outline on right hand side
end

vim.lsp.handlers["textdocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lsp_flags = {
  debounce_text_changes = 150,
}

-- change the diagnostic symbols in the sign column (gutter)
local signs = { error = " ", warn = " ", hint = "ﴞ ", info = " " }
for type, icon in pairs(signs) do
  local hl = "diagnosticsign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
--
-- configure html server
require("lspconfig")["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
})

-- configure css server
require("lspconfig")["cssls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure ltex server
-- you need to run brew install ltex-ls first
-- still does not work correctly and does not have spanish
-- https://www.reddit.com/r/neovim/comments/s24zvh/how_can_i_load_a_user_dictionary_into_ltexls/
-- https://gist.github.com/lbiaggi/a3eb761ac2fdbff774b29c88844355b8
-- https://github.com/barreiroleo/ltex_extra.nvim
-- https://neovim.discourse.group/t/help-wanted-trying-to-use-ltex-ls-server-with-nvim-lsp-code-actions-did-not-execute-correctly-i-think/421
require("lspconfig")["ltex"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "ltex-ls" },
  filetypes = { "markdown", "text", "md" },
  flags = { debounce_text_changes = 300 },
})

-- markdown
require("lspconfig")["marksman"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
--
-- configure tailwindcss server
require("lspconfig")["tailwindcss"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure emmet language server
require("lspconfig")["emmet_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
require("lspconfig")["sumneko_lua"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$vimruntime/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

-- rust tools
-- https://github.com/simrat39/rust-tools.nvim
require("rust-tools").setup({
  tools = {
    executor = require("rust-tools.executors").termopen,
    reload_workspace_from_cargo_toml = true,

    inlay_hints = {
      auto = true,
      only_current_line = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "-> ",
    },
  },

  server = {
    -- capabilities = capabilities,
    -- on_attach = on_attach,
    standalone = true,

    settings = {
      ["rust-analyzer"] = {
        assist = {
          importprefix = "by_self",
        },
        cargo = {
          allfeatures = true,
        },
        checkonsave = {
          command = "clippy",
        },
        lens = {
          references = true,
          methodreferences = true,
        },
      },
    },
  },
})

-- dap
-- https://github.com/mfussenegger/nvim-dap/issues/307
-- https://github.com/simrat39/rust-tools.nvim/wiki/debugging
require("dap").adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "/users/jj/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/adapter/codelldb",
    args = { "--port", "${port}" },
  },
}

require("dap").configurations.rust = {
  {
    name = "launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspacefolder}",
    stoponentry = false,
  },
}

require("nvim-dap-virtual-text").setup()
require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

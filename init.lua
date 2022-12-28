---------------------
-- Packer
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

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("Mofiqul/vscode.nvim")
	use("nvim-lua/plenary.nvim")
	use("mbbill/undotree")
	use("kdheepak/lazygit.nvim")
	use("junegunn/goyo.vim")
	use("preservim/vim-pencil")
	use("p00f/nvim-ts-rainbow")
	use("wakatime/vim-wakatime")
	use("moll/vim-bbye")
	use("kaputi/e-kaput.nvim")
	use("jbyuki/instant.nvim")
	use("junegunn/limelight.vim")
	use("szw/vim-maximizer")
	use("tpope/vim-surround")
	use("inkarkat/vim-ReplaceWithRegister")
	use("nvim-tree/nvim-web-devicons")
	use("simrat39/rust-tools.nvim")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("nvim-lualine/lualine.nvim")
	use("numToStr/Comment.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("nvim-tree/nvim-tree.lua")
	use("windwp/nvim-autopairs")
	use("lewis6991/gitsigns.nvim")
	use("Pocco81/auto-save.nvim")
	use("akinsho/toggleterm.nvim")
	use("glepnir/lspsaga.nvim")
	use("jose-elias-alvarez/null-ls.nvim")

	-- these are for git, do not delete, stil need to be configured
	use("sindrets/diffview.nvim")
	use("TimUntersberger/neogit")

	-- these are for debugging, do not delete, still need to be configured
	use("mfussenegger/nvim-dap")
	use("puremourning/vimspector")

	use({
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	})

	-- postgres integration
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = {
			"tpope/vim-dadbod",
			"tpope/vim-dotenv",
			"kristijanhusak/vim-dadbod-completion",
		},
	})

	use({
		"akinsho/bufferline.nvim",
		tag = "v3.*",
		requires = "nvim-tree/nvim-web-devicons",
	})

	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jayp0521/mason-null-ls.nvim",
			"j-hui/fidget.nvim",
			"onsails/lspkind.nvim",
		},
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"amarakon/nvim-cmp-lua-latex-symbols",
			"f3fora/cmp-spell",
		},
	})

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
	--
	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	command = "source <afile> | PackerCompile",
-- 	group = packer_group,
-- 	pattern = vim.fn.expand("$MYVIMRC"),
-- })

---------------------
-- Options
---------------------

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

-- vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es_mx" }
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "markdown", "text" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
-- vim.cmd([[autocmd FileType markdown setlocal spell]])
-- vim.cmd([[autocmd FileType markdown setlocal complete+=kspell]])

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.nvim_tree_width = 25

-- vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
-- vim.cmd([[hi NormalNC guibg=NONE ctermbg=NONE]])

vim.cmd([[inoremap ww println!("{:#?}",);<left><left>]])
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

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
		Count = "select count(*) from {table}",
		List = "select * from {table} order by id asc",
	},
	sqlite = {
		Describe = "PRAGMA table_info({table})",
	},
}

vim.g.db_ui_auto_execute_table_helpers = 1

-- PUT POSTGRES INFO HERE
vim.g.dbs = {
	
	dev = "postgres://postgres:mypassword@localhost:5432/my-dev-db",
}
vim.g.db_ui_save_location = "~/Documents/RUSTDEV/POSTGRS"

-- set leader key to space
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
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
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope diagnostics<CR>", opts)

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>go", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

vim.keymap.set("n", "<leader>s", function()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end, { desc = "Spelling Suggestions" })

---------------------
-- Requirements
---------------------

require("Comment").setup({
	toggler = {
		line = "gcc",
		block = "x,c",
	},
	opleader = {
		line = "gc",
		block = "x,",
	},
})
require("gitsigns").setup()
require("mason").setup()

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

require("auto-save").setup({
	enabled = true,
	trigger_events = { "InsertLeave" },
	write_all_buffers = false,
})

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

local spotify = Terminal:new({ cmd = "spt", hidden = true, direction = "float" })
function _SPOTIFY()
	spotify:toggle()
end

vim.api.nvim_set_keymap("n", "sp", "<cmd>lua _SPOTIFY()<CR>", { noremap = true, silent = true })

local dbss = Terminal:new({
	cmd = "nvim -c :DBUI",
	hidden = true,
	direction = "float",
})

function _DBSS()
	dbss:toggle()
end

vim.api.nvim_set_keymap("n", "sn", "<cmd>lua _DBSS()<CR>", { noremap = true, silent = true })

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
})

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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
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
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})

local tel = require("telescope")
local actions = require("telescope.actions")
tel.setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
})

require("vscode").setup({
	transparent = true,
	italic_comments = true,
	disable_nvimtree_bg = true,
	group_overrides = {
		BufferLineFill = { fg = "NONE" },
	},
})

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
	buffer = "[Buffer]",
	path = "[Path]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	spell = "[SP]",
	["vim-dadbod-completion"] = "[DB]",
}

require("luasnip/loaders/from_vscode").lazy_load()
local cmp = require("cmp")

-- ATTENTION! THESE MUST BE AFTER THE REQUIRE VSCODE PART OR THEY DO NOTHING
vim.api.nvim_set_hl(0, "MyNormal", { bg = "None", fg = "White" })
vim.api.nvim_set_hl(0, "MyFloatBorder", { bg = "None", fg = "#464140" })
vim.api.nvim_set_hl(0, "MyCursorLine", { bg = "#837674", fg = "White" })

-- for future sources
-- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

cmp.setup({

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<S-Tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
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
			-- https://www.youtube.com/watch?v=wcVcfozoTBM
			-- https://www.youtube.com/watch?v=uDPZ2yJS6os
			-- https://github.com/hrsh7th/nvim-cmp/issues/671
			border = "rounded",
			winhighlight = "Normal:MyNormal,FloatBorder:MyFloatBorder,CursorLine:MyCursorLine,Search:None",
		}),
		documentation = cmp.config.window.bordered({
			scrollbar = false,
			border = "rounded",
			winhighlight = "Normal:MyNormal,FloatBorder:MyFloatBorder,CursorLine:MyCursorLine,Search:None",
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
					vim_item.kind = vim_item.kind .. " " .. "[ML]"
				end
			end
			local maxwidth = 80
			vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
			return vim_item
		end,
		-- 	vim_item.kind = lspkind.presets.default[vim_item.kind]
		-- 	local menu = source_mapping[entry.source.name]
		-- 	if entry.source.name == "cmp_tabnine" then
		-- 		if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
		-- 			menu = entry.completion_item.data.detail
		-- 		end
		-- 		vim_item.kind = ""
		-- 	end
		-- 	vim_item.men = menu
		-- 	return vim_item
		-- end,
	},
})

local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
	end,
	group = autocomplete_group,
})

local cmplsps = require("lspsaga")
cmplsps.init_lsp_saga({
	move_in_saga = { prev = "<C-k>", next = "<C-j>" },
	finder_action_keys = {
		open = "<CR>",
	},
	definition_action_keys = {
		edit = "<CR>",
	},
})

-- THIS ALSO MUST BE AFTER THE VSCODE REQUIREMENT OR THE COLORS WONT WORK
require("bufferline").setup({
	options = {
		numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
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
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
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
			fg = "Yellow",
			-- bg = "White",
		},
	},
})

local custom_vscode = require("lualine.themes.vscode")
custom_vscode.normal.c.bg = "None"
custom_vscode.insert.c.bg = "None"
custom_vscode.command.c.bg = "None"
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = custom_vscode,
		component_separators = "|",
		section_separators = "",
	},
})

-- LSP CONFIG

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	local opts1 = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gl", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts1) -- show diagnostics for cursor
	vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts1) -- show definition, references
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts1) -- got to declaration
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts1) -- go to implementation
	vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", opts1) -- see available code actions
	vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts1) -- see definition and make edits in window
	vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts1) -- smart rename
	vim.keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts1) -- show  diagnostics for line
	vim.keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts1)
	vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts1) -- jump to previous diagnostic in buffer
	vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts1) -- jump to next diagnostic in buffer
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts1) -- show documentation for what is under cursor
	vim.keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts1) -- see outline on right hand side
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lsp_flags = {
	debounce_text_changes = 150,
}

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
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
-- require("lspconfig")["ltex"].setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- })

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
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

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
		capabilities = capabilities,
		on_attach = on_attach,
		standalone = true,

		settings = {
			["rust-analyzer"] = {
				assist = {
					importPrefix = "by_self",
				},
				cargo = {
					allFeatures = true,
				},
				checkOnSave = {
					command = "clippy",
				},
				lens = {
					references = true,
					methodReferences = true,
				},
			},
		},
	},

	dap = {
		adapter = {
			type = "executable",
			command = "lldb-vscode",
			name = "rt_lldb",
		},
	},
})

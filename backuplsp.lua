require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
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

vim.api.nvim_set_hl(0, "MyNormal", { bg = "None", fg = "White" })
vim.api.nvim_set_hl(0, "MyFloatBorder", { bg = "None", fg = "#464140" })
vim.api.nvim_set_hl(0, "MyCursorLine", { bg = "#837674", fg = "White" })

local luasnip = require("luasnip")
local lspkind = require("lspkind")

local source_mapping = {
	buffer = "[Buffer]",
	path = "[Path]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	spell = "[SP]",
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

require("lspsaga").setup({
	border_style = "round",
	move_in_saga = { prev = "<C-k>", next = "<C-j>" },
	finder = {
		toggle_or_open = "<CR>",
	},
	definition = {
		edit = "<CR>",
	},
})

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
-- you need to run brew install ltex-ls first
-- still does not work correctly and does not have spanish
require("lspconfig")["ltex"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "ltex-ls" },
	filetypes = { "markdown", "text" },
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
require("lspconfig")["lua_ls"].setup({
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

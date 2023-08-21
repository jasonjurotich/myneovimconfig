local lsp = require("lsp-zero")
lsp.preset("recommended")

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.ensure_installed({
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
  "ltex-ls"
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.declaration()
  end, opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set("n", "<leader>rn", function()
    vim.lsp.buf.rename()
  end, opts)
end)

require('lspconfig').ltex.setup({
  cmd = { "ltex-ls" },
  filetypes = { "markdown", "text", "md" ,"bib", "plaintext", "tex", "gitcommit", "pandoc"},
  flags = { debounce_text_changes = 300 },
  settings = {
    ltex = {
      language = "en-US",
    }
  },
})

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
    },
  },
})

lsp.skip_server_setup({ 'rust_analyzer' })

lsp.setup()

local rt = require('rust-tools')

local opts = {
  tools = {
    inlay_hints = {
      only_current_line = true,
    },
  },
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
    standalone = true,
  }
}

rt.setup(opts)

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
vim.cmd(':set winhighlight=' .. cmp.config.window.bordered().winhighlight)

local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

vim.api.nvim_set_hl(0, "MyNormal", { bg = "None", fg = "White" })
vim.api.nvim_set_hl(0, "MyFloatBorder", { bg = "None", fg = "#464140" })
vim.api.nvim_set_hl(0, "MyCursorLine", { bg = "#837674", fg = "White" })

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },

  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- lsp
    { name = "luasnip" },  -- snippets
    { name = "buffer" },   -- text within current buffer
    { name = "path" },     -- file system paths
    { name = "cmp_tabnine" },
    { name = "ltex"},
    { name = "lua-latex-symbols", option = { cache = true } },
    -- {name = 'copilot'},
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

  mapping = cmp.mapping.preset.insert({
    ["<C-y>"] = cmp.mapping.abort(),        -- close completion window
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<CR>"] = cmp.mapping.confirm({
      select = true
      -- add this line for copilot and put select to false if needed
      -- behavior = cmp.ConfirmBehavior.Replace,
    }),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-i>'] = cmp.mapping.scroll_docs(4),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),



  }),

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

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




})

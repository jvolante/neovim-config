-- Set up on_attach so we can actually use the lsp
-- sets up a bunch of keymaps for a buffer that has an
-- attached LSP

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true, buffer = bufnr, desc = 'LSP Go to declaration' }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  opts['desc'] = 'LSP Go to deffinition'
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  opts['desc'] = 'LSP Go to header'
  vim.keymap.set('n', 'gh', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  opts['desc'] = 'LSP Show symbol info'
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  opts['desc'] = 'LSP Go to implementation'
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  opts['desc'] = 'LSP Show signature help'
  vim.keymap.set('n', '<C-;>', vim.lsp.buf.signature_help, opts)
  opts['desc'] = 'LSP add workspace folder'
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  opts['desc'] = 'LSP remove workspace folder'
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  opts['desc'] = 'LSP list workspace folders'
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  opts['desc'] = 'LSP go to type deffinition'
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  opts['desc'] = 'LSP Refactor rename symbol'
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  opts['desc'] = 'LSP Find all references in quickfix'
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  opts['desc'] = 'LSP Code actions'
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  opts['desc'] = 'LSP Diagnostic expand diagnostic'
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  opts['desc'] = 'LSP Diagnostic Go to next issue'
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  opts['desc'] = 'LSP Diagnostic Go to previous issue'
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  opts['desc'] = 'LSP Diagnostic set location list'
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

  local ts = require('telescope.builtin')
  opts['desc'] = 'LSP Fuzzy search symbols in this document'
  vim.keymap.set('n', '<leader>so', ts.lsp_document_symbols, opts)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function () vim.lsp.buf.format({async = false, timeout_ms = 5000,}) end, {})
end

-- Setup nvim-cmp.
local icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "⌘",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "廓",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(function (fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif not cmp.visible() then
        cmp.complete()
      elseif cmp.get_selected_entry() ~= nil then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Expanded tab behavior to make cmp and luasnip work
    -- seamlessly
    ['<tab>'] = cmp.mapping(function (fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<s-tab>'] = cmp.mapping(function (fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  -- window = {
  -- },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  }),

  experimental = {
    ghost_text = true,
    native_menu = false,
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function (_, vim_item)
      vim_item.menu = vim_item.kind
      vim_item.kind = icons[vim_item.kind]

      return vim_item
    end,
  }
})

local neodev = require('neodev')
neodev.setup {}

-- Make sure some lsps are installed and set them up
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "lua_ls", "clangd", "cmake", "pylsp" }

local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local lsp_config = require('lspconfig')

mason.setup()
mason_lsp.setup {
  ensure_installed = servers
}

local function setup_server(server, server_specific_setup)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities
  }

  if server_specific_setup ~= nil then
    opts = server_specific_setup(opts)
  end
  lsp_config[server].setup(opts)
end

local server_specific_setups = {
  lua_ls = function(opts)
    local indent_style

    if vim.o.expandtab then
      indent_style = "space"
    else
      indent_style = "tab"
    end

    opts.settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        }
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = indent_style,
          indent_size = tostring(vim.o.tabstop),
        },
      },
      IntelliSense = {
        -- Some of these options can slow the language server down
        -- If you have issues you can try disabling them
        traceLocalSet = true,
        traceReturn = true,
        traceBeSetted = true,
        traceFieldInject = true,
      },
    }

    return opts
  end,
  pylsp = function(opts)
    opts.settings = {
      pylsp = {
        plugins = {
          jedi_completion = {
            fuzzy = true,
            eager = true,
            include_params = true,
            cache_for = {'numpy', 'pandas', 'tensorflow', 'torch', 'matplotlib', 'sklearn', 'scipy'},
          },
          jedi_signature_help = {
            enable = true,
          },
          pyflakes = {
            enabled = true,
          },
          pycodestyle = {
            enabled = true,
            ignore = {'E501', 'E231', 'E261'},
            maxLineLength = 150,
            yapf = {
              enabled = true,
            },
          },
          -- rope_completion = {
          --   enabled = true,
          --   eager = true,
          -- },
        },
      },
    }

    return opts
  end,
}

mason_lsp.setup_handlers {
  function (server_name)
    setup_server(server_name, server_specific_setups[server_name])
  end
}

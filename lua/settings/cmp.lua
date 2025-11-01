local util = require('utilities')
require('settings/luasnip')

-- Set up on_attach so we can actually use the lsp
-- sets up a bunch of keymaps for a buffer that has an
-- attached LSP

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr, desc = 'LSP Go to declaration' }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  opts['desc'] = 'LSP Go to deffinition'
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  opts['desc'] = 'LSP Go to header'
  vim.keymap.set('n', 'gh', '<cmd>LspClangdSwitchSourceHeader<CR>', opts)
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
  Unit = "󰭍",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

require'neogen'.setup { snippet_engine = "luasnip" }

vim.keymap.set('n', '<leader>gd', function () require'neogen'.generate{} end, { noremap = true, silent = true, desc = 'Generate Documentation' })

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Configure LuaSnip to prevent normal mode keys from triggering in snippet editing mode
luasnip.setup({
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
  store_selection_keys = "<Tab>",  -- Use Tab instead of default <c-k>
  enable_autosnippets = true,
  -- This fixes the issue with normal mode keys triggering when editing snippet placeholders
  history = true,
  updateevents = "TextChanged,TextChangedI",
  ft_func = nil -- To fix issue with normal mode keys in insert mode
})

-- Set up select mode mappings to prevent normal mode keys from triggering
-- This creates insert-mode like behavior when editing snippet placeholders
local chars = { 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
                'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                '0','1','2','3','4','5','6','7','8','9','`','-','=','[',']',';',',','.','/',' ' }

for _, char in ipairs(chars) do
  -- This makes each character behave like it would in insert mode when in select mode
  vim.keymap.set('s', char, char, { noremap = true })
end

if util.use_codeium() then
  require('codeium').setup {
    api = {
      host = "codeium.itools.anduril.dev"
    },
    enterprise_mode = true,
    uname = 'uname',
    uuidgen = 'uuidgen',
    curl = 'curl',
    gzip = 'gzip',
  }
end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  mapping = {
    ['<C-n>'] = function ()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        cmp.select_next_item()
      end
    end,
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
        --fallback()
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
    { name = 'codeium' },
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

-- Set up lspconfig first to get commands
local lspconfig = require('lspconfig')

-- Define default configuration for all servers
vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Define specific server configurations
vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    },
    format = {
      enable = true,
      defaultConfig = {
        indent_style = "space",
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
})

vim.lsp.config('pylsp', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        jedi_completion = {
          eager = true,
          include_params = true,
          cache_for = {'numpy', 'pandas', 'tensorflow', 'torch', 'matplotlib', 'sklearn', 'scipy'},
        },
        jedi_signature_help = {
          enable = true,
        },
        -- pylint = {
        --   enabled = true,
        --   executable = 'pylint'
        -- },
        ruff = {
          enabled = true,
          formatEnabled = true,
          executable = 'ruff',

          maxLineLength = 120,
        },
        pycodestyle = {
          enabled = false,
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
})

-- Only configure servers that need specific settings beyond the defaults

vim.lsp.config('clangd', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" } -- remove proto
})

vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = { command = 'clippy' },
      procMacro = { enable = true },
    },
  }
})

-- Disable LSP highlight, treesitter is better
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

-- Enable all LSP servers with silent=true to avoid error messages for missing servers
vim.lsp.enable({
  'lua_ls',
  'pylsp',
  'clangd',
  'bashls',
  'yamlls',
  'rust_analyzer',
  'marksman',
  'jqls',
  'jsonls',
  'glsl_analyzer',
  'buf_ls',
  'nixd',
  'nil_ls',
  'neocmake',
  'taplo',
  'tinymist'
}, true) -- The true here enables silent mode
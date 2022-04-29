-- Set up on_attach so we can actually use the lsp
-- sets up a bunch of keymaps for a buffer that has an
-- attached LSP

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gh', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-;>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
  vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.formatting, {})
end

-- Setup nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    end,
  },

  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
  },

  -- window = {
  -- },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- {name = 'vsnip'}, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- {name = 'ultisnips'}, -- For ultisnips users.
    -- {name = 'snippy'}, -- For snippy users.
  }, {
    { name = 'buffer' },
  }),

  experimental = {
    ghost_text = true,
  },
})

-- Make sure some lsps are installed and set them up
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lspInstallerServers = require('nvim-lsp-installer.servers')
local servers = { "sumneko_lua", "clangd", "cmake", "pyright", "yamlls" }

local function create_server_ready_func(server, server_specific_setup)
  return function()
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities
    }

    if server_specific_setup ~= nil then
      opts = server_specific_setup(opts)
    end
    server:setup(opts)
  end
end

local server_specific_setups = {
  sumneko_lua = function(opts)
    local indent_style

    if vim.o.expandtab then
      indent_style = "space"
    else
      indent_style = "tab"
    end

    opts.settings = {
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

    return require('lua-dev').setup {
      lspconfig = opts
    }
  end
}

for _, server_name in ipairs(servers) do
  local server_available, server = lspInstallerServers.get_server(server_name)

  if server_available then
    -- this adds a ton of latency to startup
    --server:install()

    local server_on_ready = create_server_ready_func(server, server_specific_setups[server_name])
    server:on_ready(server_on_ready)
  end
end

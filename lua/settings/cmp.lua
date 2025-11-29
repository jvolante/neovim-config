local util = require('utilities')
require('settings/luasnip')

-- Set up on_attach so we can actually use the LSP
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

  vim.api.nvim_buf_create_user_command(bufnr, 'Format',
    function() vim.lsp.buf.format({ async = false, timeout_ms = 5000, }) end, {})
end


require 'neogen'.setup { snippet_engine = "luasnip" }

vim.keymap.set('n', '<leader>gd', function() require 'neogen'.generate {} end,
  { noremap = true, silent = true, desc = 'Generate Documentation' })

local luasnip = require('luasnip')

-- Configure LuaSnip to prevent normal mode keys from triggering in snippet editing mode
luasnip.setup({
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
  store_selection_keys = "<Tab>", -- Use Tab instead of default <c-k>
  enable_autosnippets = true,
  -- This fixes the issue with normal mode keys triggering when editing snippet placeholders
  history = true,
  updateevents = "TextChanged,TextChangedI",
  ft_func = nil -- To fix issue with normal mode keys in insert mode
})

local codium_blink_opts = {}
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

  codium_blink_opts = {
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'codeium' },
      providers = {
        codeium = {
          name = 'codeium',
          module = 'blink.compat.source',
        },
      },
    },
  }
end

local blink = require('blink.cmp')

local blink_opts = {
  -- Disable cmdline
  cmdline = { enabled = false },

  completion = {
    keyword = { range = 'prefix' },

    accept = { auto_brackets = { enabled = false }, },

    -- Don't select by default, auto insert on selection
    list = { selection = { preselect = false, auto_insert = true } },

    -- Show documentation when selecting a completion item
    documentation = { auto_show = true, auto_show_delay_ms = 300 },

    -- Display a preview of the selected item on the current line
    ghost_text = { enabled = true },
  },

  sources = {
    -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  -- Use a preset for snippets, check the snippets documentation for more information
  snippets = { preset = 'luasnip' },

  -- Experimental signature help support
  signature = { enabled = true },

  keymap = {
    preset = 'none',

    ['<C-n>'] = {
      function()
        if luasnip.choice_active() then
          vim.schedule(function()
            luasnip.change_choice(1)
          end)
          return true
        end
      end,
      'select_next',
      'show_and_insert',
    },
    ['<C-p>'] = {
      function()
        if luasnip.choice_active() then
          vim.schedule(function()
            luasnip.change_choice(-1)
          end)
          return true
        end
      end,
      'select_prev',
    },
    ['<tab>'] = { 'select_and_accept', 'fallback', },
    ['<C-b>'] = { 'scroll_documentation_up' },
    ['<C-f>'] = { 'scroll_documentation_down' },
    ['<C-Space>'] = { 'snippet_forward', 'select_and_accept', 'show', },
    ['<s-tab>'] = { 'snippet_backward', 'fallback', },
    ['<C-e>'] = { 'cancel' },
  },
}

blink.setup(vim.tbl_deep_extend('force', blink_opts, codium_blink_opts))
-- -- Setup nvim-cmp.
-- local icons = {
--   Text = "",
--   Method = "",
--   Function = "",
--   Constructor = "⌘",
--   Field = "ﰠ",
--   Variable = "",
--   Class = "ﴯ",
--   Interface = "",
--   Module = "",
--   Property = "ﰠ",
--   Unit = "󰭍",
--   Value = "",
--   Enum = "",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Struct = "",
--   Event = "",
--   Operator = "",
--   TypeParameter = "",
-- }
--
-- local cmp = require('cmp')
-- cmp.setup({
--   snippet = {
--     -- REQUIRED - you must specify a snippet engine
--     expand = function(args)
--       luasnip.lsp_expand(args.body) -- For `luasnip` users.
--     end,
--   },
--
--   mapping = {
--     ['<C-n>'] = function ()
--       if luasnip.choice_active() then
--         luasnip.change_choice(1)
--       else
--         cmp.select_next_item()
--       end
--     end,
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
--     ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
--     ['<C-Space>'] = cmp.mapping(function (fallback)
--       if luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       elseif not cmp.visible() then
--         cmp.complete()
--       elseif cmp.get_selected_entry() ~= nil then
--         cmp.confirm({ select = true })
--       else
--         --fallback()
--       end
--     end, { 'i', 'c' }),
--     ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--     ['<C-e>'] = cmp.mapping({
--       i = cmp.mapping.abort(),
--       c = cmp.mapping.close(),
--     }),
--     -- Expanded tab behavior to make cmp and luasnip work
--     -- seamlessly
--     ['<tab>'] = cmp.mapping(function (fallback)
--       if cmp.visible() then
--         cmp.confirm({ select = true })
--       else
--         fallback()
--       end
--     end, {'i', 's'}),
--
--     ['<s-tab>'] = cmp.mapping(function (fallback)
--       if luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--
--   -- window = {
--   -- },
--
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' }, -- For luasnip users.
--     { name = 'codeium' },
--   }, {
--     { name = 'buffer' },
--   }),
--
--   experimental = {
--     ghost_text = true,
--     native_menu = false,
--   },
--
--   formatting = {
--     fields = { "kind", "abbr", "menu" },
--     format = function (_, vim_item)
--       vim_item.menu = vim_item.kind
--       vim_item.kind = icons[vim_item.kind]
--
--       return vim_item
--     end,
--   }
-- })

local neodev = require('neodev')
neodev.setup {}

-- Make sure some lsps are installed and set them up
local capabilities = blink.get_lsp_capabilities()

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
          cache_for = { 'numpy', 'pandas', 'tensorflow', 'torch', 'matplotlib', 'sklearn', 'scipy' },
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
          ignore = { 'E501', 'E231', 'E261' },
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

-- Harper-ls configuration for automatic spell file regeneration.
-- This setup creates a single, long-lived file watcher when harper-ls first starts.
-- When the dictionary file is changed (e.g., by using 'zg'), this watcher
-- schedules the .spl spell file to be regenerated after a 30-second delay.
-- This 'debouncing' prevents the regeneration command from running too frequently
-- if multiple words are added in quick succession.

-- State for the watcher and debouncing logic.
local spell_watcher_started = false
local regeneration_timer = nil
local spell_watcher = vim.loop.new_fs_event()

-- Function to run the regeneration and reset the timer.
local function run_regeneration()
  vim.cmd(util.mkspell_cmd)
  regeneration_timer = nil -- Reset timer to allow for future regenerations.
end

-- Callback for when the spell dictionary file changes.
local function on_spell_change(err, filename, status)
  if err then
    vim.notify("Error watching spell file: " .. err, vim.log.levels.ERROR)
    return
  end

  -- We only care about changes to the .add file, not the .spl file we generate.
  -- This prevents an infinite loop of regenerations.
  if not filename or filename ~= vim.fn.fnamemodify(spell_add_file, ":t") then
    return
  end

  -- If a regeneration is not already scheduled, schedule one.
  -- This debounces regeneration to at most once every 30 seconds.
  if not regeneration_timer then
    regeneration_timer = vim.defer_fn(run_regeneration, 30000)
  end
end

vim.lsp.config('harper_ls', {
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Don't run vim's spellcheck when Harper is running.
    vim.api.nvim_buf_set_option(bufnr, 'spell', false)

    -- Start the file watcher the first time harper_ls attaches to a buffer.
    if not spell_watcher_started then
      local spell_dir = vim.fn.fnamemodify(spell_add_file, ":h")
      spell_watcher:start(spell_dir, {}, vim.schedule_wrap(on_spell_change))
      spell_watcher_started = true
    end

    -- Emulate important parts of the normal spell functionality.
    local opts = { noremap = true, silent = true, buffer = bufnr, desc = 'Correct spelling' }
    vim.keymap.set('n', 'z=',
      function() vim.lsp.buf.code_action({ filter = function(action) return action.title:find("^Replace with") ~= nil end }) end,
      opts)
    opts["desc"] = 'Add to user dictionary'
    vim.keymap.set('n', 'zg',
      function()
        -- Just apply the code action. The file watcher will handle regeneration.
        vim.lsp.buf.code_action({ filter = function(action) return action.title:find("^Add") ~= nil and action.title:find("to the user dictionary.") ~= nil end, apply = true })
      end, opts)
  end,
  capabilities = capabilities,
  settings = {
    ["harper-ls"] = {
      userDictPath = spell_add_file,
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
  'tinymist',
  'harper_ls',
}, true) -- The true here enables silent mode
local fn = vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo
local util = require('utilities')

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  -- Colorschemes
  -- {
  --   'mcchrish/zenbones.nvim', -- zenbones/zenflesh/zenwritten/...
  --   dependencies = { 'rktjmp/lush.nvim' },
  --   lazy = false,
  --   priority = 1000,
  --   config = function () vim.cmd 'colorscheme forestbones' end,
  -- },
  {
    'rose-pine/neovim', -- zenbones/zenflesh/zenwritten/...
    as = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function () vim.cmd 'colorscheme rose-pine' end,
  },
  {'nvim-telescope/telescope-fzf-native.nvim', build='make' },
  require 'settings/aerial',
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_formatter = '<author> - <author_time>',
        current_line_blame_opts = {
          virt_text = false,
          virt_text_pos = 'right_align',
          delay = 1000,
          ignore_whitespace = true,
        }
      }
    end,
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = vim.fn.executable('git'),
  },
  {
    'stevearc/dressing.nvim',
    config = function ()
      require('dressing').setup {
        input = {
          options = {
            winblend = 0,
          },
          relative = "editor",
        },
      }
    end,
    dependencies = {'nvim-telescope/telescope.nvim'},
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    'rcarriga/nvim-notify',
    config = function () vim.notify = require('notify') end,
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.notify = function(...)
        require("lazy").load({ plugins = { "nvim-notify" }})
        return vim.notify(...)
      end
    end,
  },
  {
    'ggandor/leap.nvim',
    dependencies = {'ggandor/leap-spooky.nvim'},
    config = function ()
      require('leap-spooky').setup()
    end,
    keys = {
      { 's', '<Plug>(leap-forward)', mode = { 'n', 'v', 'o' }, desc = 'Leap search forward' },
      { 'S', '<Plug>(leap-backward)', mode = { 'n', 'v', 'o' }, desc = 'Leap search backward' },
      { 'gs', '<Plug>(leap-cross-window)', mode = { 'n', 'v', 'o' }, desc = 'Leap search cross window' },
      { 'i', mode = { 'o' }, },
      { 'a', mode = { 'o' }, },
    },
  },
  'kyazdani42/nvim-web-devicons',
  {
    'gbprod/substitute.nvim',
    config = function ()
      require("substitute").setup()
    end,
    keys = {
      {"<tab>", function () require('substitute').operator() end, mode = "n", desc = 'replace text selected with operator'},
      {"<tab><tab>", function () require('substitute').line() end, mode = "n", desc = 'replace entire line'},
      {"<s-tab>", function () require('substitute').eol() end, mode = "n", desc = 'replace until end of line'},
      {"<tab>", function () require('substitute').visual() end, mode = "x", desc = 'replace visually selected text'},
    },
  },
  {
    'Pocco81/auto-save.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function ()
      local autosave = require("auto-save")

      autosave.setup {
        condition = function(buf)
          local utils = require("auto-save.utils.data")

          if
            fn.getbufvar(buf, "&modifiable") == 1 and
            fn.bufname(buf) ~= nil and
            #fn.bufname(buf) > 0 and
            utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
            return true -- met condition(s), can save
          end
          return false -- can't save
        end,
        debounce_delay = 1000
      }
    end,
  },
  {
    'folke/persistence.nvim',
    config = function ()
      local persistence = require('persistence')
      persistence.setup {}

      vim.api.nvim_create_user_command('Restore', function()
          persistence.load {last = true}
      end, {})
    end,
  },
  {
    'RaafatTurki/hex.nvim',
    config = function ()
      require'hex'.setup()
    end,
    enabled = vim.fn.executable('xxd'),
    cmd = {'HexToggle', 'HexAssemble', 'HexDump'},
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function () require('settings/lualine') end,
  },
  -- require('settings/dial'),
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
    },
    config = function () require'settings/treesitter' end,
    build = ':TSUpdate',
  },
  {
    'numToStr/Comment.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function () require('Comment').setup() end,
    keys = {
      {'gc', mode = {'v', 'n'}, desc = 'Comment toggle linewise'},
      {'gb', mode = {'v', 'n'}, desc = 'Comment toggle blockwise'},
      {'gco', desc = 'Comment insert below'},
      {'gcO', desc = 'Comment insert above'},
    },
  },
  require('settings/neogit'),
  require('settings/telescope'),

  -- Autocomplete stuff
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'folke/neodev.nvim',
      'nvim-telescope/telescope.nvim',
      -- 'jcdickinson/codeium.nvim',
    },
    config = function () require('settings/cmp') end,
  },

  require'settings/debug',
  require'settings/yabs',

  {
    'kevinhwang91/nvim-bqf',
    config = function () require('settings/bqf') end,
  },
  'tpope/vim-repeat',
  {
    'romainl/vim-cool',
    keys = {'/', '<cmd>'},
  },
  'peterhoeg/vim-qml',
  {
    'bkad/CamelCaseMotion',
    keys = {
      {'W', '<Plug>CamelCaseMotion_w', mode = { 'n', 'v', 'o' }, desc = 'Camelcase forward word motion'},
      {'B', '<Plug>CamelCaseMotion_b', mode = { 'n', 'v', 'o' }, desc = 'Camelcase backward word motion'},
    },
  },
  -- {
  --   'wellle/targets.vim',
  --   keys = {
  --     { 'i', mode = { 'o' }, },
  --     { 'a', mode = { 'o' }, },
  --   },
  -- },
  {
    'tpope/vim-eunuch',
    enabled = require('utilities').isUnix,
  },
}
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
  {
    'mcchrish/zenbones.nvim', -- zenbones/zenflesh/zenwritten/...
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = false,
    priority = 1000,
    config = function () vim.cmd 'colorscheme forestbones' end,
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require'gitsigns'.setup {
        current_line_blame = true,
        current_line_blame_formatter = '<author> - <author_time>',
        current_line_blame_opts = {
          virt_text = false,
          virt_text_pos = 'right_align',
          delay = 1500,
          ignore_whitespace = true,
        }
      }
    end,
  },
  {
    'stevearc/dressing.nvim',
    opt = {
      input = {
        options = {
          winblend = 0,
        },
        relative = "editor",
      },
    },
    dependencies = {'nvim-telescope/telescope.nvim'},
  },
  {
    'rcarriga/nvim-notify',
    config = function () vim.notify = require('notify') end,
  },
  {
    'ggandor/leap.nvim',
    config = function ()
      vim.keymap.set({ 'n', 'v', 'o' }, 's', '<Plug>(leap-forward)')
      vim.keymap.set({ 'n', 'v', 'o' }, 'S', '<Plug>(leap-backward)')
      vim.keymap.set('n', 'gs', '<Plug>(leap-cross-window)')
    end,
  },
  'kyazdani42/nvim-web-devicons',
  {
    'gbprod/substitute.nvim',
    config = function ()
      require("substitute").setup()

      vim.keymap.set("n", "<tab>", require('substitute').operator)
      vim.keymap.set("n", "<tab><tab>", require('substitute').line)
      vim.keymap.set("n", "<s-tab>", require('substitute').eol)
      vim.keymap.set("x", "<tab>", require('substitute').visual)
    end
  },
  {
    'Pocco81/auto-save.nvim',
    event = { 'InsertLeave', 'TextChanged' },
    config = function ()
      local autosave = require("auto-save")

      autosave.setup {
        condition = function(buf)
          local fn = vim.fn
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
    config = function () require('settings/lualine') end,
  },
  {
    'monaqa/dial.nvim',
    config = function () require('settings/dial') end,
    keys = { '<c-a>', '<c-x>' },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    conifg = function () require'settings/treesitter' end,
    build = ':TSUpdate',
  },
  {
    'numToStr/Comment.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function () require('Comment').setup() end,
    keys = {'gc', 'gb'},
  },
  -- {
  --   'TimUntersberger/neogit',
  --   requires = 'nvim-lua/plenary.nvim'
  --   config = function () require('settings/neogit') end,
  --   cmd = 'Neogit',
  -- },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function () require('settings/telescope') end,
  },

  -- Autocomplete stuff
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'folke/neodev.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function () require('settings/cmp') end,
  },

  -- Debug stuff
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
    },
    config = function () require'settings/debug' end,
  },

  {
    'stevearc/overseer.nvim',
    config = function () require('settings/yabs') end,
  },

  {
    'kevinhwang91/nvim-bqf',
    config = function () require('settings/bqf') end,
  },
  {
    'pwntester/octo.nvim',
    config = function ()
      require'octo'.setup {
        default_remote = { 'origin', 'upstream' },
      }
    end,
  },

  'tpope/vim-repeat',
  'romainl/vim-cool',
  'peterhoeg/vim-qml',
  {
    'bkad/CamelCaseMotion',
    config = function ()
      vim.keymap.set({ 'n', 'v', 'o' }, 'W', '<Plug>CamelCaseMotion_w')
      vim.keymap.set({ 'n', 'v', 'o' }, 'B', '<Plug>CamelCaseMotion_b')
    end
  },

  {
    'tpope/vim-eunuch',
    enabled = require('utilities').isUnix,
  },
}

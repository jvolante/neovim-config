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

  -- Lua plugins
  'lewis6991/impatient.nvim',
  'lewis6991/gitsigns.nvim',
  'stevearc/dressing.nvim',
  {
    'rcarriga/nvim-notify',
    config = function () vim.notify = require('notify') end,
  },
  'ggandor/leap.nvim',
  'kyazdani42/nvim-web-devicons',
  'gbprod/substitute.nvim',
  'Pocco81/auto-save.nvim',
  'folke/persistence.nvim',
  'RaafatTurki/hex.nvim',
  'anuvyklack/hydra.nvim',
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
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
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
  -- }
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
    config = function () require('settings/telescope') end,
  },

  -- Autocomplete stuff
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/nvim-cmp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'folke/neodev.nvim',

  -- Debug stuff
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'mfussenegger/nvim-dap-python',

  {
    'stevearc/overseer.nvim',
    config = function () require('settings/yabs') end,
  },

  'kevinhwang91/nvim-bqf',
  'pwntester/octo.nvim',

  'tpope/vim-repeat',
  'romainl/vim-cool',
  'peterhoeg/vim-qml',
  'bkad/CamelCaseMotion',

  {
    'tpope/vim-eunuch',
    cond = require('utilities').isUnix,
  },
}

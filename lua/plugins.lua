local fn = vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

local gitlab = 'https://gitlab.com/'
-- Bootstrap paq
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  --use 'kdheepak/monochrome.nvim'
  --use 'rose-pine/neovim' -- g.rose_pine_variant | base moon dawn
  use {
    'mcchrish/zenbones.nvim', -- zenbones/zenflesh/zenwritten/...
    requires = 'rktjmp/lush.nvim'
  }
  --use 'FrenzyExists/aquarium-vim'
  --use 'EdenEast/nightfox.nvim'
  --use 'kvrohit/substrata.nvim'
  --use 'rmehri01/onenord.nvim'
  --use 'kyazdani42/blue-moon'
  --use 'sainnhe/everforest'
  --use 'projekt0n/github-nvim-theme'

  -- Lua plugins
  use 'ggandor/lightspeed.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'gbprod/substitute.nvim'
  use 'Pocco81/AutoSave.nvim'
  use 'sindrets/diffview.nvim'
  use  {
    gitlab..'yorickpeterse/nvim-window.git',
    as = 'nvim-window'
  }

  use {
    'nvim-neorg/neorg',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    'nvim-lualine/lualine.nvim',
  }

  use {
    'monaqa/dial.nvim',
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'numToStr/Comment.nvim'
    --run = ':TSUpdate'
  }

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use {
    'glepnir/dashboard-nvim',
    requires = {{'nvim-telescope/telescope.nvim'}}
  }

  -- Autocomplete stuff
  use {
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  }

  use 'tpope/vim-sleuth'
  use 'tpope/vim-repeat'
  use 'romainl/vim-cool'
  use 'peterhoeg/vim-qml'

  if packerBootstrap then
    require('packer').sync()
  end
end)

local fn = vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

local gitlab = 'https://gitlab.com/'
-- Bootstrap paq
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  use 'kdheepak/monochrome.nvim'
  use 'rose-pine/neovim' -- g.rose_pine_variant | base moon dawn
  use {
    'mcchrish/zenbones.nvim', -- zenbones/zenflesh/zenwritten/...
    requires = 'rktjmp/lush.nvim'
  }
  use 'FrenzyExists/aquarium-vim'
  use 'EdenEast/nightfox.nvim'
  use 'kvrohit/substrata.nvim'
  use 'rmehri01/onenord.nvim'
  use 'kyazdani42/blue-moon'
  use 'sainnhe/everforest'
  use 'projekt0n/github-nvim-theme'

  use 'ggandor/lightspeed.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'lewis6991/gitsigns.nvim'
  use 'Pocco81/AutoSave.nvim'
  use 'sindrets/diffview.nvim'
  use  {
    gitlab..'yorickpeterse/nvim-window.git',
    as = 'nvim-window'
  }
  --[[
  use {
    'nvim-neorg/neorg',
    requires = 'nvim-lua/plenary.nvim'
  }
  ]]--
  use {
    'nvim-lualine/lualine.nvim',
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    --run = ':TSUpdate'
  }

  use {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim'
  }

  use {
    'jghauser/mkdir.nvim',
    config = function()
      require('mkdir')
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use {
    'glepnir/dashboard-nvim',
    requires = {{'nvim-telescope/telescope.nvim'}}
  }

  use 'tpope/vim-sleuth'
  use 'tpope/vim-repeat'
  use 'romainl/vim-cool'
  use 'peterhoeg/vim-qml'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

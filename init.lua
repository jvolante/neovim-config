-- Load plugins and plugin settings
require('plugins')

local telescope_success     = pcall(function () require('settings/telescope') end)
local dashboard_success     = pcall(function () require('settings/dashboard') end)
local autosave_success      = pcall(function () require('settings/autosave') end)
local neogit_success        = pcall(function () require('settings/neogit') end)
local treesitter_success    = pcall(function () require('settings/treesitter') end)
local diffview_successs     = pcall(function () require('settings/diffview') end)
local neorg_successs     = pcall(function () require('settings/neorg') end)
local nvim_window_success     = pcall(function () require('settings/window') end)
local lualine_success     = pcall(function () require('settings/lualine') end)
--local cmp_success     = pcall(function () require('settings/cmp') end)
require('settings/cmp')

local util = require('utilities')
local noremap = util.noremap
local fn = vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

-- colorscheme
vim.cmd("colorscheme forestbones")

vim.cmd("set mouse=a")
vim.cmd("set autoread")
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

noremap('n', '<c-h>', '<c-w>h')
noremap('n', '<c-j>', '<c-w>j')
noremap('n', '<c-k>', '<c-w>k')
noremap('n', '<c-l>', '<c-w>l')


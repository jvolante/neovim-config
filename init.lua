-- Load plugins and plugin settings
require('plugins')

local telescope_success = pcall(function () require('settings/telescope') end)
local dashboard_success = pcall(function () require('settings/dashboard') end)
local autosave_success  = pcall(function () require('settings/autosave') end)
local neogit_success    = pcall(function () require('settings/neogit') end)
local neogit_success    = pcall(function () require('settings/treesitter') end)

local util = require('utilities')
local noremap = util.noremap
local fn = vim.fn
local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo

-- colorscheme
vim.cmd("colorscheme everforest")

vim.cmd("set mouse=a")
vim.cmd("set autoread")
vim.cmd("autocmd BufWritePost plugins.lua PackerCompile")

noremap('n', '<c-h>', '<c-w>h')
noremap('n', '<c-j>', '<c-w>j')
noremap('n', '<c-k>', '<c-w>k')
noremap('n', '<c-l>', '<c-w>l')


local fn = vim.fn
local g = vim.g
-- set, setglobal, setlocal (for window), setlocal (for buffer) respectively
local o, go, wo, bo = vim.o, vim.go, vim.wo, vim.bo

-- Super important stuff to do first, loading plugins may change
-- these options
g.mapleader = ","

o.mouse = "a"
o.autoread = true
o.swapfile = false
o.scrolloff = 5
o.showmode = false
o.foldlevelstart = 99
o.foldmethod = "syntax"
o.foldminlines = 10
o.foldopen = "all"
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

-- Load plugins and plugin settings
require('plugins')

-- Configure plugins, for some reason packer config option doesn't seem
-- to work on Windows
local telescope_success = pcall(require, 'settings/telescope')
local dashboard_success = pcall(require, 'settings/dashboard')
local autosave_success = pcall(require, 'settings/autosave')
local neogit_success = pcall(require, 'settings/neogit')
local treesitter_success = pcall(require, 'settings/treesitter')
local diffview_successs = pcall(require, 'settings/diffview')
local neorg_successs = pcall(require, 'settings/neorg')
local nvim_window_success = pcall(require, 'settings/window')
local lualine_success = pcall(require, 'settings/lualine')
local cmp_success = pcall(require, 'settings/cmp')
local substitute_success = pcall(require, 'settings/substitute')
local lualine_success = pcall(require, 'settings/dial')

local util = require('utilities')
local noremap = util.noremap

-- colorscheme
pcall(vim.cmd, "colorscheme forestbones")

noremap('n', '<c-h>', '<c-w>h')
noremap('n', '<c-j>', '<c-w>j')
noremap('n', '<c-k>', '<c-w>k')
noremap('n', '<c-l>', '<c-w>l')

noremap('n', 'W', 'b')

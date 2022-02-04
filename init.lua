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
require('settings')

local util = require('utilities')
local noremap = util.noremap

-- colorscheme
pcall(vim.cmd, "colorscheme forestbones")

noremap('n', '<c-h>', '<c-w>h')
noremap('n', '<c-j>', '<c-w>j')
noremap('n', '<c-k>', '<c-w>k')
noremap('n', '<c-l>', '<c-w>l')

noremap('n', '<F5>', '<cmd>e!<cr>')

noremap('n', 'W', 'b')

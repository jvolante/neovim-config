-- improve startuptime
pcall(require, 'impatient')

local g = vim.g
local util = require('utilities')
-- set, setglobal, setlocal (for window), setlocal (for buffer) respectively
local o, go, wo, bo = vim.o, vim.go, vim.wo, vim.bo

-- Stop neovim from looking everywhere for the python program
-- this can improve startuptime
g.python3_host_prog = 'python3'
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
o.breakindent = true
o.linebreak = true
o.cursorline = true
o.lazyredraw = true

-- Load plugins and plugin settings
require('plugins')
-- Load custom functionality
require('functionality')

-- Configure plugins, for some reason packer config option doesn't seem
-- to work on Windows
require('settings')

-- colorscheme
pcall(vim.cmd, "colorscheme forestbones")

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<c-q>', '<cmd>q<cr>')

vim.keymap.set('n', '<F5>', '<cmd>e!<cr>')

-- Stop caffine on windows from being wierd
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<F15>', '')
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<c-F15>', '')
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<s-F15>', '')

vim.keymap.set({ 'n', 'v', 'o' }, 's', '<Plug>(leap-forward)')
vim.keymap.set({ 'n', 'v', 'o' }, 'S', '<Plug>(leap-backward)')
vim.keymap.set('n', 'gs', '<Plug>(leap-cross-window)')

vim.keymap.set('i', '<c-l>', '<c-r>"')

local proj_settings = require('functionality.project_settings')

proj_settings.register_settings_handler('indent',
  function(indent_length) util.setupIndent(indent_length, vim.o) end,
  2)

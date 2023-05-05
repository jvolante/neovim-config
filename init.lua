local g = vim.g
local util = require('utilities')
-- set, setglobal, setlocal (for window), setlocal (for buffer) respectively
local o, go, wo, bo = vim.o, vim.go, vim.wo, vim.bo

-- Stop neovim from looking everywhere for the python program
-- this can improve startuptime
if util.isUnix then
  g.python3_host_prog = 'python3'
else
  g.python3_host_prog = 'python'
end

-- Super important stuff to do first, loading plugins may change
-- these options
g.mapleader = ","

o.mouse = "a"
o.mousemodel = "extend"
o.autoread = true
o.swapfile = false
o.scrolloff = 10
o.showmode = false
o.foldlevelstart = 99
o.foldmethod = "syntax"
o.foldminlines = 10
o.breakindent = true
o.linebreak = true
o.number = false
o.cursorline = true
o.lazyredraw = true
o.termguicolors = true
o.signcolumn = 'yes'
 o.undodir = o.undodir .. ',/tmp/nvim'
 o.undofile = true

-- Load plugins and plugin settings
require('plugins')
-- Load custom functionality
require('functionality')

vim.keymap.set('n', '<c-h>', '<c-w>h', {desc = 'Jump window left'})
vim.keymap.set('n', '<c-j>', '<c-w>j', {desc = 'Jump window down'})
vim.keymap.set('n', '<c-k>', '<c-w>k', {desc = 'Jump window up'})
vim.keymap.set('n', '<c-l>', '<c-w>l', {desc = 'Jump window right'})

vim.keymap.set('n', '<c-q>', '<cmd>q<cr>', {desc = 'Close window'})

vim.keymap.set('n', '<F5>', '<cmd>e!<cr>', {desc = 'Reload buffer'})

-- Stop caffine on windows from being wierd
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<F15>', '', {desc = 'noop Fix behavior with caffine'})
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<c-F15>', '', {desc = 'noop Fix behavior with caffine'})
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<s-F15>', '', {desc = 'noop Fix behavior with caffine'})

-- make terminal mode less annoying
vim.keymap.set('t', '<c-\\>', '<c-\\><c-N>', {desc = 'Leave insert terminal mode'})

-- easy put while in insert mode
vim.keymap.set('i', '<c-l>', '<c-r>"', {desc = 'Insert mode put'})

-- if the terminal/gui gets resized, resize all the splits to defaults
vim.api.nvim_create_autocmd("VimResized", {
  pattern = '*',
  callback = function ()
    local keys = vim.api.nvim_replace_termcodes("<c-w>=", true, true, true)
    vim.fn.feedkeys(keys, 'n')
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {'json',},
  command = 'set foldlevel=2'
})

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
end

local proj_settings = require('functionality.project_settings')

proj_settings.register_settings_handler('indent',
  function(indent_length) util.setupIndent(indent_length, o) end,
  4)

-- set font for gui
proj_settings.register_settings_handler('guifont',
  function(guifont_string) pcall(function () o.guifont = guifont_string end) end,
  "CartographCF Nerd Font:h6")

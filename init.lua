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
o.cursorline = true
o.lazyredraw = true
o.termguicolors = true

-- Load plugins and plugin settings
require('plugins')
-- Load custom functionality
require('functionality')

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

-- make terminal mode less annoying
vim.keymap.set('t', '<c-\\>', '<c-\\><c-N>')

-- easy put while in insert mode
vim.keymap.set('i', '<c-l>', '<c-r>"')

local proj_settings = require('functionality.project_settings')

proj_settings.register_settings_handler('indent',
  function(indent_length) util.setupIndent(indent_length, vim.o) end,
  2)

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

vim.o.guifont = "CartographCF Nerd Font:h7"

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
end

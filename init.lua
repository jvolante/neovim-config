local fn = vim.fn
local g = vim.g
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
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.breakindent = true
o.breakindentopt = 'shift:4'
o.linebreak = true
o.cursorline = true

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

vim.keymap.set('n', 'W', 'b')

-- Stop caffine on windows from being wierd
vim.keymap.set({'n', 'v', 'x', 'i'}, '<F15>', '')

vim.keymap.set({'n', 'v', 'o'}, 's', '<Plug>(leap-omni)')
vim.keymap.set('n', 'S', '<Plug>(leap-cross-window)')

--g.do_filetype_lua = true
--g.did_load_filetypes = false

-- load user platform settings, I use this for stuff that isn't the same
-- install to install
local userSetup, err = loadfile(vim.env.HOME .. '/.nvimUserSettings')
if userSetup ~= nil then
  userSetup()
else
  print("User preferences not loaded")
  print(err)
end

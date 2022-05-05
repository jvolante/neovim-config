-- improve startuptime
-- require('impatient')

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

local function setDefaultDirPreferences(scope)
  util.setupIndent(2, scope)
end

setDefaultDirPreferences(o)

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
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<F15>', '')
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<c-F15>', '')
vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<s-F15>', '')

vim.keymap.set({ 'n', 'v', 'o' }, 's', '<Plug>(leap-forward)')
vim.keymap.set({ 'n', 'v', 'o' }, 'S', '<Plug>(leap-backward)')
vim.keymap.set('n', 'gs', '<Plug>(leap-cross-window)')

vim.keymap.set('i', '<c-l>', '<c-r>"')

-- Switch to experimental lua filetype detection
-- significantly improves startuptime
-- might not work for esoteric filetypes
g.do_filetype_lua = 1
g.did_load_filetypes = 0

-- TODO: These custom config loaders are probably a bit of a security risk, and I
-- should probably change them to load a json file or something

-- load user platform settings, I use this for stuff that isn't the same
-- install to install
local userSetupFname = vim.env.HOME .. '/.nvimUserSettings'
local userSetup, err = loadfile(userSetupFname)
if userSetup ~= nil then
  userSetup()
else
  if err ~= "cannot open " .. userSetupFname .. ": No such file or directory" then
    vim.schedule(function()
      print(err)
      print("User preferences not loaded")
    end)
  end
end

-- load workspace local settings, ussually use this to set build tasks
-- and indent options on a per project basis
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = { '*' },
  callback = function()
    local dirConfigFname = '.nvim/nvimProject.lua'
    local dirSetup, errr = loadfile(dirConfigFname)
    local scope = o
    if dirSetup ~= nil then
      local setup = dirSetup()
      -- possibly change this later to work with per tab working dirs
      setup(scope)
    else
      if errr ~= "cannot open " .. dirConfigFname .. ": No such file or directory" then
        vim.schedule(function()
            print(errr)
            print("Project preferences not loaded")
        end)
      end
      setDefaultDirPreferences(scope)
    end
  end,
})


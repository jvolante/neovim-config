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

  -- Stop caffeine on windows from being weird
  vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<F15>', '', {desc = 'noop Fix behavior with caffine'})
  vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<c-F15>', '', {desc = 'noop Fix behavior with caffine'})
  vim.keymap.set({ 'n', 'v', 'o', 's', 'i', 'c', 't' }, '<s-F15>', '', {desc = 'noop Fix behavior with caffine'})
end

-- Super important stuff to do first, loading plugins may change
-- these options
g.mapleader = ","
g.maplocalleader = ",,"

o.mouse = "nv"
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
o.signcolumn = 'yes'
o.undodir = o.undodir .. ',' .. os.getenv('HOME') .. '/.local/state/nvim/undo/'
o.undofile = true
o.spelllang = "en_us"
o.spell = true
o.inccommand = 'split'
o.termguicolors = true -- fixes colors over some ssh connections

o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = 0
o.expandtab = true
o.breakindentopt = 'shift:' .. tostring(o.tabstop * 2)

vim.opt.wildignore:append({'*.javac', 'node_modules', '*.aux', '*.out', '*.toc', '*.o', '*.obj', '*.dll', '*.exe', '*.so', '*.a', '*.lib', '*.pyc', '*.pyo', '*.pyd', '*.swp', '*.swo', '*.class', '.DS_Store', '.git', '.hg', '.orig', '*.lock', '*.onnx'})
vim.opt.suffixesadd:append({'.java', '.rs'})

vim.opt.diffopt:append("linematch:50")

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

-- make terminal mode less annoying
vim.keymap.set('t', '<c-\\>', '<c-\\><c-N>', {desc = 'Leave insert terminal mode'})

-- easy put while in insert mode
vim.keymap.set('i', '<c-l>', '<c-r>"', {desc = 'Insert mode put'})

-- insert current date and time
vim.keymap.set('i', '<c-d>', function()
  return os.date('%Y-%m-%d %I:%M %p')
end, {expr = true, desc = 'Insert current date and time'})

vim.keymap.set('n', '<leader>ll', util.copy_github_link, {desc = 'Copy link to current line for forge'})
vim.keymap.set('n', '<leader>dr', util.convert_deg_to_rad, {desc = 'Convert degrees to radians under cursor'})

vim.api.nvim_create_user_command('Config',
  function ()
    if vim.fn.bufname("%") ~= '' then
      vim.cmd 'tabnew'
    end
    vim.cmd('tc ' .. vim.fn.stdpath('config'))
    vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')
  end, {})

-- if the terminal/gui gets resized, resize all the splits to defaults
vim.api.nvim_create_autocmd("VimResized", {
  pattern = '*',
  callback = function ()
    local keys = vim.api.nvim_replace_termcodes("<c-w>", true, true, true)
    vim.fn.feedkeys(keys, 'n')
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {'json',},
  command = 'set foldlevel=2'
})

vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function() vim.schedule(function()
    if vim.fn.filereadable(util.spell_add_file) == 1 then
      local add_mtime = vim.fn.getftime(util.spell_add_file)
      local spl_mtime = vim.fn.getftime(util.spell_spl_file)
 
      -- Run mkspell! only if .add is newer than .add.spl or .add.spl doesn't exist
      if add_mtime > spl_mtime or spl_mtime == -1 then
        vim.cmd(util.mkspell_cmd)
      end
    end
  end) end,
})

local proj_settings = require('functionality.project_settings')

-- set font for gui
proj_settings.register_settings_handler('guifont',
  function(guifont_string) pcall(function () o.guifont = guifont_string end) end,
  "CartographCF Nerd Font:h6")

-- custom filetypes
vim.filetype.add({
  extension = {
    typ = 'typst',
  },
})

-- Set breakindent shift width from editorconfig
require('editorconfig').properties.indent_size = function (bufnr, val, opts)
  bo[bufnr].softtabstop = tonumber(val)
  bo[bufnr].shiftwidth = tonumber(val)
  vim.cmd("set breakindentopt=shift:" .. tostring(val * 2))
end
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

-- Open vertical split terminal running Claude to implement TODOs
-- Claude edits a temporary copy of the project, then changes are merged via diff patch
vim.keymap.set('n', '<leader>ct', function()
  local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local cwd = vim.fn.getcwd()

  -- Create temporary directory and copy project using copy-on-write if available
  local temp_dir = vim.fn.tempname() .. '_project'
  vim.fn.mkdir(temp_dir, 'p')

  -- Use cp --reflink=auto for COW support (fast on btrfs/XFS, falls back to regular copy)
  vim.notify('Copying project to temporary directory...', vim.log.levels.INFO)
  local copy_result = vim.fn.system('cp -r --reflink=auto "' .. cwd .. '/." "' .. temp_dir .. '/"')

  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to copy project: ' .. copy_result, vim.log.levels.ERROR)
    vim.fn.delete(temp_dir, 'rf')
    return
  end

  local temp_file = temp_dir .. '/' .. current_file

  vim.cmd('vsplit | enew')
  local win = vim.api.nvim_get_current_win()
  vim.fn.termopen('cd "' .. temp_dir .. '" && claude "Implement any TODOs you find in ' .. current_file .. '"', {
    on_exit = function(job_id, exit_code, event)
      vim.notify('Claude finished, merging changes...', vim.log.levels.INFO)

      -- Find all modified files by comparing directories
      local diff_cmd = 'diff -ruN "' .. cwd .. '" "' .. temp_dir .. '" | grep "^diff " | sed "s|^diff -ruN ||" | awk \'{print $1}\' | sed "s|' .. vim.fn.escape(cwd, '/') .. '/||"'
      local changed_files = vim.fn.systemlist(diff_cmd)

      local patches_applied = 0
      local patches_failed = 0

      -- Generate and apply patches for each changed file
      for _, rel_file in ipairs(changed_files) do
        local orig_file = cwd .. '/' .. rel_file
        local temp_file_path = temp_dir .. '/' .. rel_file

        -- Skip if temp file doesn't exist (deleted file) or orig doesn't exist (new file)
        if vim.fn.filereadable(temp_file_path) == 1 and vim.fn.filereadable(orig_file) == 1 then
          local diff_output = vim.fn.system('diff -u "' .. orig_file .. '" "' .. temp_file_path .. '"')

          if vim.v.shell_error ~= 0 and diff_output ~= '' then
            local patch_result = vim.fn.system('patch "' .. orig_file .. '"', diff_output)

            if vim.v.shell_error == 0 then
              patches_applied = patches_applied + 1
            else
              patches_failed = patches_failed + 1
              vim.notify('Failed to patch ' .. rel_file .. ': ' .. patch_result, vim.log.levels.WARN)
            end
          end
        elseif vim.fn.filereadable(temp_file_path) == 1 then
          -- New file created
          vim.fn.system('cp "' .. temp_file_path .. '" "' .. orig_file .. '"')
          patches_applied = patches_applied + 1
        end
      end

      -- Clean up temp directory
      vim.fn.delete(temp_dir, 'rf')

      -- Reload buffers to show changes
      vim.cmd('checktime')

      if patches_applied > 0 then
        vim.notify('Merged ' .. patches_applied .. ' file(s) from Claude', vim.log.levels.INFO)
      else
        vim.notify('No changes to merge', vim.log.levels.INFO)
      end

      if patches_failed > 0 then
        vim.notify('Failed to merge ' .. patches_failed .. ' file(s)', vim.log.levels.WARN)
      end

      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
  })
  vim.cmd('startinsert')
end, {desc = 'Run Claude TODO implementation with diff merge'})

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
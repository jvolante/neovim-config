-- Enable treesitter highlighting for filetypes with installed parsers.
-- nvim 0.12 automatically enables highlighting for its bundled parsers
-- (c, lua, markdown, vim, vimdoc, query) via ftplugin. This autocmd covers
-- the remaining parsers managed outside of nvim-treesitter.
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'bash', 'sh',
    'cmake',
    'cpp', 'cuda',
    'json', 'json5', 'jsonc',
    'nix',
    'proto',
    'python',
    'rust',
    'toml',
    'yaml',
  },
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- nvim-treesitter-textobjects (main branch) setup
require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer']  = 'V',
      ['@function.inner']  = 'V',
      ['@class.outer']     = 'V',
      ['@class.inner']     = 'V',
    },
  },
  move = {
    set_jumps = true,
  },
}

local select = require('nvim-treesitter-textobjects.select')
local move   = require('nvim-treesitter-textobjects.move')
local modes  = { 'x', 'o' }

-- Select textobjects
vim.keymap.set(modes, 'am', function() select.select_textobject('@function.outer', 'textobjects') end, { desc = 'Select outer function' })
vim.keymap.set(modes, 'im', function() select.select_textobject('@function.inner', 'textobjects') end, { desc = 'Select inner function' })
vim.keymap.set(modes, 'ac', function() select.select_textobject('@class.outer',    'textobjects') end, { desc = 'Select outer class' })
vim.keymap.set(modes, 'ic', function() select.select_textobject('@class.inner',    'textobjects') end, { desc = 'Select inner class' })
vim.keymap.set(modes, 'al', function() select.select_textobject('@loop.outer',     'textobjects') end, { desc = 'Select outer loop' })
vim.keymap.set(modes, 'il', function() select.select_textobject('@loop.inner',     'textobjects') end, { desc = 'Select inner loop' })
vim.keymap.set(modes, 'aa', function() select.select_textobject('@parameter.outer','textobjects') end, { desc = 'Select outer parameter' })
vim.keymap.set(modes, 'ia', function() select.select_textobject('@parameter.inner','textobjects') end, { desc = 'Select inner parameter' })

-- Move motions
local nm = { 'n', 'x', 'o' }
vim.keymap.set(nm, ']m', function() move.goto_next_start('@function.outer',  'textobjects') end, { desc = 'Next function start' })
vim.keymap.set(nm, '[m', function() move.goto_previous_start('@function.outer',  'textobjects') end, { desc = 'Prev function start' })
vim.keymap.set(nm, ']M', function() move.goto_next_end('@function.outer',    'textobjects') end, { desc = 'Next function end' })
vim.keymap.set(nm, '[M', function() move.goto_previous_end('@function.outer','textobjects') end, { desc = 'Prev function end' })

vim.keymap.set(nm, ']]', function() move.goto_next_start('@class.outer',     'textobjects') end, { desc = 'Next class start' })
vim.keymap.set(nm, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev class start' })
vim.keymap.set(nm, ']C', function() move.goto_next_end('@class.outer',       'textobjects') end, { desc = 'Next class end' })
vim.keymap.set(nm, '[C', function() move.goto_previous_end('@class.outer',   'textobjects') end, { desc = 'Prev class end' })

vim.keymap.set(nm, ']d', function() move.goto_next('@conditional.outer',     'textobjects') end, { desc = 'Next conditional' })
vim.keymap.set(nm, '[d', function() move.goto_previous('@conditional.outer', 'textobjects') end, { desc = 'Prev conditional' })

require('markview').setup {
  preview = {
    icon_provider = "devicons",
    filetypes = { "markdown", "quarto", "rmd", "Avante" },
  },
}

-- Disable markview preview when entering any non-rendered mode so it doesn't
-- auto-restore on return to normal mode. Re-enable manually (e.g. :Markview).
local rendered_modes = { n = true, no = true, c = true }
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function(args)
    local new_mode = vim.v.event.new_mode
    if rendered_modes[new_mode] then
      return
    end
    local state = require("markview.state")
    if state.enabled() and state.buf_attached(args.buf) then
      require("markview.actions").disable(args.buf)
    end
  end,
})

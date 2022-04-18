local actions = require('telescope.actions')
local config = require('telescope.config')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-p>', builtin.find_files)
vim.keymap.set('n', 'gB', builtin.buffers)
vim.keymap.set('n', '<leader>/', builtin.live_grep)
vim.keymap.set('n', '<F1>', builtin.help_tags)
-- TODO: Make this keymap only bind in git repos
vim.keymap.set('n', '<F2>', builtin.git_branches)

require('telescope').load_extension('yabs')

-- This function is used to disable keys that may be processed 
-- by vim (such as player controls) but shouldn't
local function noop(buffnr) end

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<ESC>'] = actions.close,
        ['<c-CR>'] = actions.select_vertical,
        ['<s-CR>'] = actions.select_horizontal,
        -- Keep player controls and others from causing telescope to act strange
        ['<F15>'] = noop,
        ['<c-F15>'] = noop,
        ['<s-F15>'] = noop,
        ['<80>'] = noop,
        ['<c-80>'] = noop,
        ['<s-80>'] = noop,
        ['<82>'] = noop,
        ['<c-82>'] = noop,
        ['<s-82>'] = noop,
        ['<83>'] = noop,
        ['<c-83>'] = noop,
        ['<s-83>'] = noop,
        ['<86>'] = noop,
        ['<c-86>'] = noop,
        ['<s-86>'] = noop,
      }
    },
    prompt_prefix = ' 🔍 ',
  },
  pickers = {
    find_files = {
      previewer = false,
      theme = 'ivy',
    },
    buffers = {
      previewer = false,
      theme = 'ivy',
    },
    git_branches = {
      previewer = false,
      mappings = {
        i = {
          ['<CR>'] = actions.git_switch_branch,
          ['<c-CR>'] = actions.git_merge_branch,
        },
      },
    },
  },
}

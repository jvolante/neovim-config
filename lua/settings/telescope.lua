local actions = require('telescope.actions')
local config = require('telescope.config')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<c-p>', builtin.find_files)
vim.keymap.set('n', 'gB', builtin.buffers)
vim.keymap.set('n', '<leader>/', builtin.live_grep)
vim.keymap.set('n', '<F1>', builtin.help_tags)

require('telescope').load_extension('yabs')
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<ESC>'] = actions.close
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
    }
  }
}

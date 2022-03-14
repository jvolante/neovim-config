local actions = require('telescope.actions')
local config = require('telescope.config')

vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files)
vim.keymap.set('n', 'gB', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep)

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

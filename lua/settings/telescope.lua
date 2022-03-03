local actions = require('telescope.actions')
local config = require('telescope.config')

vim.keymap.set('n', '<c-p>', function() require('telescope.builtin').find_files({ previewer=false }) end)
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
    }
  }
}

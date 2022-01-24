local actions = require('telescope.actions')
local config = require('telescope.config')
local util = require('utilities')

local noremap = util.noremap

noremap('n', '<c-p>', '<cmd>Telescope find_files previewer=false<cr>')
noremap('n', '<leader>/', '<cmd>Telescope live_grep<cr>')

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

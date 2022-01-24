local actions = require('telescope.actions')
local config = require('telescope.config')
local util = require('utilities')

local noremap = util.noremap

noremap('n', '<c-p>', '<cmd>Telescope find_files previewer=false<cr>')

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

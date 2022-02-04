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

local colors = require('colors').get()
local fg = require('core.utils').fg
local bg = require('core.utils').bg
local fg_bg = require('core.utils').fg_bg

fg_bg("TelescopeBorder", colors.darker_black, colors.darker_black)
fg_bg("TelescopePromptBorder", colors.black2, colors.black2)

fg_bg("TelescopePromptNormal", colors.white, colors.black2)
fg_bg("TelescopePromptPrefix", colors.red, colors.black2)

bg("TelescopeNormal", colors.darker_black)

fg_bg("TelescopePreviewTitle", colors.black, colors.green)
fg_bg("TelescopePromptTitle", colors.black, colors.red)
fg_bg("TelescopeResultsTitle", colors.darker_black, colors.darker_black)

bg("TelescopeSelection", colors.black2)

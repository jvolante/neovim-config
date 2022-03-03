local augend = require('dial.augend')

require("dial.config").augends:register_group{
  default = {
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.integer.alias.binary,
    augend.constant.alias.bool,
    augend.constant.new {
      elements = {"True", "False"},
      word = true,
      cyclic = true,
    },
    augend.date.alias["%Y/%m/%d"],
  },
}

vim.keymap.set('n', '<c-a>', '<Plug>(dial-increment)')
vim.keymap.set('n', '<c-x>', '<Plug>(dial-decrement)')
vim.keymap.set('v', '<c-a>', '<Plug>(dial-increment)')
vim.keymap.set('v', '<c-x>', '<Plug>(dial-decrement)')
vim.keymap.set('v', 'g<c-a>', 'g<Plug>(dial-increment)')
vim.keymap.set('v', 'g<c-x>', 'g<Plug>(dial-decrement)')

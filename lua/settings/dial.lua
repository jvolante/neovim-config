return {
  'monaqa/dial.nvim',
  config = function ()
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
  end,
  keys = {
    {'<c-a>', '<Plug>(dial-increment)', mode = {'n', 'x'}, desc = 'increment text under cursor'},
    {'<c-x>', '<Plug>(dial-decrement)', mode = {'n', 'x'}, desc = 'decrement text under cursor'},
    {'g<c-a>', 'g<Plug>(dial-increment)', mode = 'x', desc = 'increment selected lines to form a sequence'},
    {'g<c-x>', 'g<Plug>(dial-decrement)', mode = 'x', desc = 'decrement selected lines to form a sequence'},
  },
}
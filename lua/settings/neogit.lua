return {
  'TimUntersberger/neogit',
  requires = 'nvim-lua/plenary.nvim',
  config = function ()
    local neogit = require('neogit')

    neogit.setup {}
  end,
  cmd = 'Neogit',
  keys = {
    {'<c-g>', ':Neogit<cr>', desc = 'Open Neogit git viewer'},
  },
  enabled = vim.fn.executable('git'),
}

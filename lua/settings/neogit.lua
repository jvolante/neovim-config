local neogit = require('neogit')
local util = require('utilities')
local noremap = util.noremap

neogit.setup {}

noremap('n', '<c-g>', '<cmd>Neogit<cr>')

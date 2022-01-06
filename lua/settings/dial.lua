local util = require('utilities')
local map = util.map

map('n', '<c-a>', '<Plug>(dial-increment)')
map('n', '<c-v>', '<Plug>(dial-decrement)')
map('v', '<c-a>', '<Plug>(dial-increment)')
map('v', '<c-v>', '<Plug>(dial-decrement)')

local util = require('utilities')

local noremap = util.noremap

noremap('n', '<c-w>', '<cmd>lua require("nvim-window").pick()<CR>')

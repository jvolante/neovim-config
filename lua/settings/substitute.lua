require("substitute").setup()

local util = require('utilities')
local noremap = util.noremap

noremap("n", "r", "<cmd>lua require('substitute').operator()<cr>")
noremap("n", "rr", "<cmd>lua require('substitute').line()<cr>")
noremap("n", "R", "<cmd>lua require('substitute').eol()<cr>")
noremap("x", "r", "<cmd>lua require('substitute').visual()<cr>")

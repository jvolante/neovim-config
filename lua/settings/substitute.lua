require("substitute").setup()

local util = require('utilities')
local noremap = util.noremap

noremap("n", "<tab>", "<cmd>lua require('substitute').operator()<cr>")
noremap("n", "<tab><tab>", "<cmd>lua require('substitute').line()<cr>")
noremap("n", "<s-tab>", "<cmd>lua require('substitute').eol()<cr>")
noremap("x", "<tab>", "<cmd>lua require('substitute').visual()<cr>")

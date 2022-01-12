local dial = require("dial")

dial.augends["custom#boolean"] = dial.common.enum_cyclic {
  name = "boolean",
  strlist = {"true", "false"}
}

dial.augends["custom#booleanUpper"] = dial.common.enum_cyclic {
  name = "booleanUpper",
  strlist = {"True", "False"}
}

table.insert(dial.config.searchlist.normal, "custom#boolean")
table.insert(dial.config.searchlist.normal, "custom#booleanUpper")

local util = require('utilities')
local map = util.map

map('n', '<c-a>', '<Plug>(dial-increment)')
map('n', '<c-x>', '<Plug>(dial-decrement)')
map('v', '<c-a>', '<Plug>(dial-increment)')
map('v', '<c-x>', '<Plug>(dial-decrement)')

local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

local indent = '    '
ls.add_snippets('python', {
  s("def", {
    t("def "), i(1, "function_name"), t("("), i(2, "parameters"), t(") -> "), i(3, "return_type"), t({":", indent}),
    t({"'''", indent}),
    i(4, "A short description"), t({'', '', indent}),
    f(copy, 2), t({'', indent .. "'''", indent}),
    i(5, 'body')}),
  s("main", {
    t({"def main():",
        indent .. "from argparse import ArgumentParser",
        indent .. "parser = ArgumentParser(description=__doc__)", '', indent}),
        i(1, 'add arguments'), t({'', '', indent .. "args = parser.parse_args()", '', indent}),
        i(2, 'body'), t({'',
        '',
        '',
        'if __name__ == "__main__":',
        indent .. "main()"})
    }),
  s("numpy", {t("import numpy as np")}),
  s("pandas", {t("import pandas as pd")}),
  s("pyplot", {t("import matplotlib.pyplot as plt")}),
  s("path", {t("from pathlib import Path")}),
})

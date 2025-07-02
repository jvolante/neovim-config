local utils = require('utilities')
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
local fmt = require"luasnip.extras.fmt".fmt

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

local indent = '\t'
ls.add_snippets('python', {
  s("def", {
    t("def "), i(1, "function_name"), t("("), i(2, "parameters"), t(") -> "), i(3, "return_type"), t({":", '\t'}),
    t({"'''", "\t"}),
    i(4, "A short description"), t({'', '', "\t"}),
    f(copy, 2), t({'', '\t"""', "\t"}),
    i(5, 'body')}),
  s("main", {
    t({"def main() -> None:",
        "\tfrom argparse import ArgumentParser",
        "\tparser = ArgumentParser(description=__doc__)", '', indent}),
        i(1, 'add arguments'), t({'', '', "\targs = parser.parse_args()", '', '\t'}),
        i(2, 'body'), t({'',
        '',
        '',
        'if __name__ == "__main__":',
        "\tmain()"})
    }),
  s("partial", {t("from functools import partial")}),
  s("numpy", {t("import numpy as np")}),
  s("cupy", {t("import cupy as cp")}),
  s("pandas", {t("import pandas as pd")}),
  s("polars", {t("import polars as pl")}),
  s("pyplot", {t("import matplotlib.pyplot as plt")}),
  s("path", {t("from pathlib import Path")}),
  s("executor_import", {t("from concurrent.futures import "), c(1, {t("Thread"), t("Process")}), t("PoolExecutor")}),
  s("__author__", {t("__author__ = \""), f(utils.get_user_name), t(" <"), f(utils.get_user_email), t(">\"")}),
  s("numpy_generator", {i(1, "_default_generator"), t(" = np.random.default_rng()")}),
  s("json_load", fmt([[
  with open({}) as f:
  \\t{} = json.load(f)
  ]], { i(1, "json_path"), i(2, "json_data") })),
})
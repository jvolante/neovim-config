require("substitute").setup()

vim.keymap.set("n", "<tab>", require('substitute').operator)
vim.keymap.set("n", "<tab><tab>", require('substitute').line)
vim.keymap.set("n", "<s-tab>", require('substitute').eol)
vim.keymap.set("x", "<tab>", require('substitute').visual)

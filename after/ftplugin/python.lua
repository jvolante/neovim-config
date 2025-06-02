vim.bo.makeprg = [[ruff check --output-format concise]]
vim.bo.errorformat = [[%f:%l:%c:%m]]
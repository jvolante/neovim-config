vim.cmd [[autocmd BufWritePre * lua require('functionality/auto_mkdir').run()]]

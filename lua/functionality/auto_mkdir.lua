local M = {}

function M.run()
  local dir = vim.fn.expand('%:p:h')

  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { '*' },
  callback = M.run
})


return M

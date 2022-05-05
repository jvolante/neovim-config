require'functionality.auto_mkdir'
require'functionality.sync_settings'
require'functionality.platform_project_settings'.setup()

-- Start at the last read line when opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = { '*' },
  callback = function ()
    local line_result = vim.fn.line("'\"")
    if line_result > 0 and line_result <= vim.fn.line("$") then
      vim.cmd("exe \"normal! g'\\\"\"")
    end
  end})

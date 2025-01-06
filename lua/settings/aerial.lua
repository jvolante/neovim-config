return {
  'stevearc/aerial.nvim',
  config = function ()
    require 'aerial'.setup{}
  end,
  lazy = false,
  keys = {
    { '<leader>O', function () vim.cmd ":AerialToggle" end, desc = "Toggle outline" },
    { '<leader>o', function () vim.cmd ":AerialNavOpen" end, desc = "Open outline navigator" },
  },
}
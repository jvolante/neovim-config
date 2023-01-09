-- local neogit = require('neogit')
--
-- neogit.setup {
--   integrations = {
--     diffview = true
--   }
-- }


vim.g.lazygit_floating_window_use_plenary = 1
-- vim.keymap.set('n', '<c-g>', neogit.open)
vim.keymap.set('n', '<c-g>', '<cmd>LazyGit<cr>')

-- set up github integration
require'octo'.setup {
  default_remote = { 'origin', 'upstream' },
}

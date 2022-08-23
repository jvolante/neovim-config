local neogit = require('neogit')

neogit.setup {
  integrations = {
    diffview = true
  }
}

vim.keymap.set('n', '<c-g>', neogit.open)

-- set up github integration
require'octo'.setup {
  default_remote = { 'origin', 'upstream' },
}

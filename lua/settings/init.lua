local util = require('utilities')

-- set up vim notify
util.error_wrap(function () vim.notify = require('notify') end)

util.error_wrap(require, 'settings/telescope')
-- util.error_wrap(require, 'settings/neogit')
util.error_wrap(require, 'settings/treesitter')
util.error_wrap(require, 'settings/lualine')
util.error_wrap(require, 'settings/cmp')
util.error_wrap(require, 'settings/dial')
util.error_wrap(require, 'settings/yabs')
util.error_wrap(require, 'settings/bqf')
util.error_wrap(require, 'settings/debug')

-- set up autosave
util.error_wrap(function()
  local autosave = require("auto-save")

  autosave.setup {
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      if
        fn.getbufvar(buf, "&modifiable") == 1 and
        fn.bufname(buf) ~= nil and
        #fn.bufname(buf) > 0 and
        utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true -- met condition(s), can save
      end
      return false -- can't save
    end,
    debounce_delay = 1000
  }
end)

-- set up persistence
util.error_wrap(function()
  local persistence = require('persistence')
  persistence.setup {}

  vim.api.nvim_create_user_command('Restore', function()
      persistence.load {last = true}
  end, {})
end)

-- set up hex
util.error_wrap(function ()
  local hex = require'hex'
  hex.setup()
end)

-- set up octo
util.error_wrap(function ()
  require'octo'.setup {
    default_remote = { 'origin', 'upstream' },
  }
end)

-- set up substitute
util.error_wrap(function ()
  require("substitute").setup()

  vim.keymap.set("n", "<tab>", require('substitute').operator)
  vim.keymap.set("n", "<tab><tab>", require('substitute').line)
  vim.keymap.set("n", "<s-tab>", require('substitute').eol)
  vim.keymap.set("x", "<tab>", require('substitute').visual)
end)

-- set up comment
util.error_wrap(function ()
  require('Comment').setup()
end)

-- set up dressing
util.error_wrap(function ()
  require'dressing'.setup {
    input = {
      options = {
        winblend = 0,
      },
      relative = "editor",
    },
  }
end)

-- set up gitsigns
util.error_wrap(function ()
  require'gitsigns'.setup {
    current_line_blame = true,
    current_line_blame_formatter = '<author> - <author_time>',
    current_line_blame_opts = {
      virt_text = false,
      virt_text_pos = 'right_align',
      delay = 1500,
      ignore_whitespace = true,
    }
  }
end)

-- set up camelcase
vim.keymap.set({ 'n', 'v', 'o' }, 'W', '<Plug>CamelCaseMotion_w')
vim.keymap.set({ 'n', 'v', 'o' }, 'B', '<Plug>CamelCaseMotion_b')

require('settings/telescope')
require('settings/autosave')
require('settings/neogit')
require('settings/treesitter')
require('settings/lualine')
require('settings/cmp')
require('settings/substitute')
require('settings/dial')
require('settings/comment')
require('settings/yabs')
require('settings/camelcase')
require('settings/bqf')
require('settings/dressing')
require('settings/debug')

-- set up vim notify
local notify_ok, notify = pcall(require, 'notify')
if notify_ok then
  vim.notify = notify
else
  vim.schedule(function () vim.pretty_print(notify) end)
end

-- set up persistence
local persistence_ok, persistence = pcall(require, 'persistence')
if persistence_ok then
  persistence.setup {}

  vim.api.nvim_create_user_command('Restore', function()
      persistence.load {last = true}
  end, {})
else
  vim.schedule(function () vim.pretty_print(persistence) end)
end



vim.keymap.set('n', '<leader>b', '<cmd>Telescope yabs tasks<cr>')

require('functionality.platform_project_settings').register_settings_handler('tasks',
  function(tasks_dict)
    local out = 'buffer'
    local opts = { open_on_run = 'always' }
    local final_dict = {}

    for task, command in pairs(tasks_dict) do
      final_dict[task] = {
        command = command,
        output = out,
        opts = opts
      }
    end
    require('yabs'):setup { tasks = final_dict }
  end,
  {})

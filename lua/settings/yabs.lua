vim.keymap.set('n', '<leader>b', '<cmd>OverseerRun<cr>')

local overseer = require('overseer')

overseer.setup {
  dap = false,

  task_list = {
    bindings = {
      ["?"] = "ShowHelp",
      ["<CR>"] = "RunAction",
      ["<C-e>"] = "Edit",
      ["o"] = "Open",
      ["<C-v>"] = "OpenVsplit",
      ["<C-f>"] = "OpenFloat",
      ["p"] = "TogglePreview",
      ["<C-u>"] = "IncreaseDetail",
      ["<C-i>"] = "DecreaseDetail",
      ["L"] = "IncreaseAllDetail",
      ["H"] = "DecreaseAllDetail",
      ["["] = "DecreaseWidth",
      ["]"] = "IncreaseWidth",
      ["{"] = "PrevTask",
      ["}"] = "NextTask",
    },
  },

  pre_task_hook = function (task_defn, util)
    -- auto open the task list when starting a task
    -- vim.cmd("OverseerOpen")
  end
}

require('functionality.project_settings').register_settings_handler('tasks',
  function(tasks_dict)
    for task, command in pairs(tasks_dict) do

      overseer.register_template {
        name = task,
        builder = function (params)
          return { cmd = command }
        end,
      }
    end
  end,
  {})

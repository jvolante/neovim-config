return {
  'stevearc/overseer.nvim',
  config = function ()

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
      templates = {"builtin", 'user.build', 'user.configure', 'user.clean', 'user.nix_build'},
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
  end,
  keys = {
    {'<leader>b', '<cmd>OverseerRun<cr>', desc = 'Select a task to run'},
  },
  cmd = {
    'OverseerOpen',
    'OverseerRun',
    'OverseerBuild',
    'OverseerToggle',
    'OverseerRunCmd',
    'OverseerQuickAction',
  },
}

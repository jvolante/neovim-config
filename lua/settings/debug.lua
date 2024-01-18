return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap-python',
  },
  config = function ()
    local dap = require('dap')
    local dapui = require('dapui')
    local dap_python = require('dap-python')

    -- PDB setup
    if require('utilities').isUnix then
        dap_python.setup('~/.virtualenvs/debugpy/bin/python')
    else
        dap_python.setup('~/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python')
    end
    dap_python.test_runner = 'pytest'

    -- GDB setup
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" }
    }

    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.rust = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
      },
    }

    dapui.setup({
      icons = { expanded = "", collapsed = "", current_frame = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Use this to override mappings for specific elements
      element_mappings = {
        -- Example:
        -- stacks = {
        --   open = "<CR>",
        --   expand = "o",
        -- }
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7") == 1,
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
        {
          elements = {
          -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
      controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = true,
        -- Display controls in this element
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "",
          terminate = "",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      }
    })

    vim.api.nvim_create_user_command("Debug", dapui.toggle, {})
  end,
  keys = {
    {'<leader><leader>b', function () require'dap'.toggle_breakpoint() end, desc = 'Toggle breakpoint'},
    {'<leader><leader>s', function () require'dap'.step_over() end, desc = 'Debug step over'},
    {'<leader><leader>i', function () require'dap'.step_into() end, desc = 'Debug step into'},
    {'<leader><leader>o', function () require'dap'.step_out() end, desc = 'Debug step out of'},
    {'<leader><leader>c', function () require'dap'.continue() end, desc = 'Debug continue'},
    {'<leader><leader>K', function () require'dap'.terminate() end, desc = 'Debug terminate session'},
    {'<leader><leader>h', function () require('dap.ui.widgets').hover() end, desc = 'Debug get info for symbol'},
    {'<leader><leader>C', function ()
      require'dap'.clear_breakpoints()
      vim.notify('Breakpoints Cleared', vim.log.levels.INFO)
    end, desc = 'Clear all breakpoints'},
  },
  cmd = {'Debug'},
}
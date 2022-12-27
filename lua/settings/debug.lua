local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then
  vim.notify('nvim-dap not installed', vim.log.levels.WARN)
  return
end

local dapui_ok, dapui = pcall(require, 'dapui')
if not dapui_ok then
  vim.notify('nvim-dap-ui not installed', vim.log.levels.WARN)
  return
end

local dap_python_ok, dap_python = pcall(require, 'dap-python')
if not dap_python_ok then
  vim.notify('nvim-dap-python not installed', vim.log.levels.WARN)
else
  if require('utilities').isUnix then
      dap_python.setup('~/.virtualenvs/debugpy/bin/python')
  else
      dap_python.setup('~/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python')
  end
  dap_python.test_runner = 'pytest'
end

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

vim.keymap.set('n', '<leader><leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader><leader>s', dap.step_over)
vim.keymap.set('n', '<leader><leader>i', dap.step_into)
vim.keymap.set('n', '<leader><leader>o', dap.step_out)
vim.keymap.set('n', '<leader><leader>c', dap.continue)
vim.keymap.set('n', '<leader><leader>K', dap.terminate)
vim.keymap.set('n', '<leader><leader>h', require('dap.ui.widgets').hover)
vim.keymap.set('n', '<leader><leader>C', function ()
  dap.clear_breakpoints()
  vim.notify('Breakpoints Cleared', vim.log.levels.INFO)
end)

vim.api.nvim_create_user_command("Debug", function ()
  dapui.toggle()
end, {})

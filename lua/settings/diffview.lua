return {
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local actions = require("diffview.actions")
    require('diffview').setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      default_args = {
        DiffviewOpen = { "-uno" },
      },
      keymaps = {
        view = {
          { "n", "q", actions.close, { desc = "Close diffview" } },
        },
      },
    })
  end,
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewFileHistory' },
  keys = {
    { '<leader>dv', '<cmd>DiffviewOpen<cr>', desc = 'Open DiffView' },
  },
  enabled = vim.fn.executable('git') == 1,
}
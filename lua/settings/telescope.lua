local actions = require('telescope.actions')
local config = require('telescope.config')
local builtin = require('telescope.builtin')

require('telescope').load_extension('yabs')

vim.keymap.set('n', '<c-p>',
  function ()
    local ok = pcall(builtin.git_files)
    if not ok then
      builtin.find_files()
    end
  end)

vim.keymap.set('n', 'gB', builtin.buffers)
vim.keymap.set('n', '<leader>/', builtin.live_grep)
vim.keymap.set('n', '<F1>', builtin.help_tags)
-- TODO: Make this keymap only bind in git repos
vim.keymap.set('n', '<F2>', builtin.git_branches)


-- This function is used to disable keys that may be processed 
-- by vim, like <F15> from caffine, but shouldn't
local function noop(buffnr) end

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<ESC>'] = actions.close,
        ['<c-CR>'] = actions.select_vertical,
        ['<s-CR>'] = actions.select_horizontal,
        ['<c-q>'] = function (buffnr)
          vim.cmd('cexpr []')
          actions.smart_add_to_qflist(buffnr)

          -- Open the quickfix list and disable word wrap
          vim.cmd('vert copen 60')
          vim.wo.wrap = false
        end,
        -- Keep player controls and others from causing telescope to act strange
        ['<F15>'] = noop,
        ['<c-F15>'] = noop,
        ['<s-F15>'] = noop,
      }
    },
    prompt_prefix = ' 🔍 ',
  },
  pickers = {
    find_files = {
      previewer = false,
      theme = 'ivy',
    },
    git_files = {
      previewer = false,
      theme = 'ivy',
    },
    buffers = {
      previewer = false,
      theme = 'ivy',
    },
    git_branches = {
      previewer = false,
      theme = 'ivy',
      mappings = {
        i = {
          ['<CR>'] = actions.git_switch_branch,
          ['<c-CR>'] = actions.git_merge_branch,
        },
      },
    },
  },
}

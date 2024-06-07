return {
  'nvim-telescope/telescope.nvim',
  dependencies = {'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim'},
  config = function ()
    local actions = require('telescope.actions')

    -- This function is used to disable keys that may be processed 
    -- by vim, like <F15> from caffine, but shouldn't
    local function noop(buffnr) end

    require('telescope').setup{
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      },
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
              -- vim.cmd('vert copen 80')
              vim.cmd('copen')
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

    require('telescope').load_extension('fzf')

    -- WORKAROUND: fix issue with telescope where folds don't work
    -- when a file is opened with it
    vim.api.nvim_create_autocmd('BufAdd', {
      pattern = '*',
      command = 'normal zX',
    })
  end,
  keys = {
    {'<leader><space>', function () require'telescope.builtin'.find_files() end, desc = 'File fuzzy finder'},
    {'gB', function () require'telescope.builtin'.buffers() end, desc = 'Buffer fuzzy finder'},
    {'<leader>/', function () require'telescope.builtin'.live_grep() end, desc = 'Global search current directory'},
    {'<F1>', function () require'telescope.builtin'.keymaps() end, desc = 'Fuzzy search keymaps'},
    {'<s-F1>', function () require'telescope.builtin'.help_tags() end, desc = 'Fuzzy search help docs'},
    -- TODO: Make this keymap only bind in git repos
    {'<F2>', function () require'telescope.builtin'.git_branches() end, desc = 'Fuzzy search and checkout git branches'},
  },
  cmd = 'Telescope',
}
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

-- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

require('nvim-treesitter.configs').setup {
  sync_install = false,
  auto_install = true,

  ensure_installed = { 'python', 'cpp', 'c', 'cuda', 'rust', 'json', 'json5', 'cmake', 'bash', 'lua', 'vim', 'markdown', 'proto', 'nix' },

  indent = {
    enable = false,
  },

  highlight = {
    enable = true,
    additional_vim_regex_higlighting = false,
  },

  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]s"] = {
          query = "@scope",
          query_group = "locals",
          desc = "Next scope"
        }
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer"
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]C"] = "@class.outer"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[C"] = "@class.outer"
      },
      goto_next = { ["]d"] = "@conditional.outer" },
      goto_previous = { ["[d"] = "@conditional.outer" }
    },
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
      selection_modes = {
        ["@parameter.outer"] = "v",
        ["@function.outer"] = "V",
        ["@function.inner"] = "V",
        ["@class.outer"] = "V",
        ["@class.inner"] = "V",
      },
    },
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ['.'] = 'textsubjects-smart',
      ['as'] = 'textsubjects-outer',
      ['is'] = 'textsubjects-inner',
    },
  },
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

require('markview').setup {
  preview = {
    icon_provider = "devicons",
    filetypes = { "markdown", "quarto", "rmd", "Avante" }, -- Add Avante while keeping all default filetypes
  },
}

-- Disable markview preview when entering any non-rendered mode so it doesn't
-- auto-restore on return to normal mode. Re-enable manually (e.g. :Markview).
local rendered_modes = { n = true, no = true, c = true }
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function(args)
    local new_mode = vim.v.event.new_mode
    if rendered_modes[new_mode] then
      return
    end
    local state = require("markview.state")
    if state.enabled() and state.buf_attached(args.buf) then
      require("markview.actions").disable(args.buf)
    end
  end,
})
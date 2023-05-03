local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

require('nvim-treesitter.configs').setup {
  -- ensure_installed = {'python', 'cpp', 'c', 'rust', 'json', 'json5', 'cmake', 'bash', 'lua', 'vim', 'markdown', 'proto', 'nix'},

  indent = {
    enable = true,
  },

  highlight = {
    enable = true
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      }
    }
  }
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

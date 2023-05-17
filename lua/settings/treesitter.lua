local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

require('nvim-treesitter.configs').setup {
  -- ensure_installed = {'python', 'cpp', 'c', 'rust', 'json', 'json5', 'cmake', 'bash', 'lua', 'vim', 'markdown', 'proto', 'nix'},

  indent = {
    enable = false,
  },

  highlight = {
    enable = true,
    additional_vim_regex_higlighting = false,
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
  },

  textsubjects = {
    enable = true,
    keymaps = {
      ['.'] = 'textsubjects-smart',
      ['as'] = 'textsubjects-outer',
      ['is'] = 'textsubjects-inner',
    }
  }
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

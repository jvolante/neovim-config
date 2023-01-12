local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.qml = {
  install_info = {
    url = "https://github.com/wingsandsuch/tree-sitter-qml.git",
    files = { "src/parser.c" },
    branch = "develop"
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {'cpp', 'c', 'rust', 'json', 'json5', 'cmake', 'bash', 'lua', 'vim', 'markdown', 'comment'},

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

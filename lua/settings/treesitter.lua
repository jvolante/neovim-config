local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {
    url = 'https://github.com/nvim-neorg/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main'
  },
}

parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main"
  },
}

parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main"
  },
}

parser_configs.xml = {
  install_info = {
    url = "https://github.com/unhammer/tree-sitter-xml",
    files = { "src/parser.c" },
    branch = "master"
  },
}

parser_configs.qml = {
  install_info = {
    url = "https://github.com/wingsandsuch/tree-sitter-qml.git",
    files = { "src/parser.c" },
    branch = "develop"
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {'norg_meta', 'norg_table', 'cpp', 'c', 'rust', 'json', 'json5', 'cmake', 'bash', 'lua', 'vim', 'xml', 'markdown', 'comment'},

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

vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")

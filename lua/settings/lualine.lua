local function blame()
  local blame = vim.b.gitsigns_blame_line
  blame = blame == nil and '' or blame
  return blame
end

local lsp_progress = require'lsp-progress'
lsp_progress.setup()

local lualine = require'lualine'
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'everforest',
    component_separators = { left = '', right = ''},
    --component_separators = { left = '\\', right = '/'},
    --section_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', {'diagnostics', sources={'nvim_diagnostic'}}},
    lualine_c = {'filename', 'aerial'},
    lualine_x = {'overseer', function ()
      return lsp_progress.progress()
    end},
    lualine_y = {'filetype'},
    lualine_z = {blame, 'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = lualine.refresh,
})
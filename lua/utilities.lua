local keymap = vim.api.nvim_set_keymap

return {
  noremap = function (mode, i, o)
    keymap(mode, i, o, {noremap=true})
  end,

  map = function (mode, i, o)
    keymap(mode, i, o, {noremap=false})
  end
}

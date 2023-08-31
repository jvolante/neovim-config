local util = require('utilities')
local function find_wd()
  return util.find_containing_dir('flake.nix', true, ';/.', -1)
end

return {
  name = "Nix Build",
  builder = function ()
    return {
      cmd = {"nix"},
      args = {"build"},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
      cwd = find_wd(),
    }
  end,
  desc = 'Build Nix flake',
  condition = {
    callback = function (search)
      return find_wd() ~= nil
    end,
  },
}

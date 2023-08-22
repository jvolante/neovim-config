local util = require('utilities')
local function find_wd()
  -- TODO figure out how to manage if we want to build a submodule separately
  return util.find_containing_dir('build', false, ';/.', -1)
end

return {
  name = "Clean",
  builder = function ()
    return {
      cmd = {"rm"},
      args = {"-rf", "build",},
      components = {"default"},
      cwd = find_wd(),
    }
  end,
  condition = {
    callback = function (search)
      return find_wd() ~= nil
    end,
  },
}

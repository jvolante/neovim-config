local util = require('utilities')
local function find_wd()
  -- TODO figure out how to manage if we want to build a submodule separately
  return util.find_containing_dir('CMakeLists.txt', true, ';/.', -1)
end

return {
  name = "Configure",
  builder = function ()
    return {
      cmd = {"cmake"},
      args = {"-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_EXPORT_COMPILE_COMMANDS=true", "-B", "build",},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
      cwd = find_wd(),
    }
  end,
  desc = 'Run cmake configure',
  condition = {
    callback = function (search)
      return find_wd() ~= nil
    end,
  },
}

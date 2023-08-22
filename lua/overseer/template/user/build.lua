local function find_wd()
  -- TODO figure out how to manage if we want to build a submodule separately
  local dirs = vim.fn.finddir('build', ';/.', -1)

  if #dirs == 0 then
    return nil
  end

  local top_build = dirs[#dirs]

  return top_build
end

-- return {
--   name = "Build",
--   builder = function ()
--     return {
--       cmd = {"cmake"},
--       args = {"--build", "build", "--config", "Release", "--target", "all", "-j", "16", "--"},
--       components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
--     }
--   end
-- }
return {
  name = "Build",
  builder = function ()
    return {
      cmd = {"make"},
      args = {"-j", "18",},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
      cwd = find_wd(),
    }
  end,
  condition = {
    callback = function (search)
      return find_wd() ~= nil
    end,
  },
}

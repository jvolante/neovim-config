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
      args = {"-C", "build", "-j", "18",},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
    }
  end
}

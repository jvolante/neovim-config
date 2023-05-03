return {
  name = "Configure",
  builder = function ()
    return {
      cmd = {"cmake"},
      args = {"-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_EXPORT_COMPILE_COMMANDS=true", "-B", "build",},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
    }
  end
}

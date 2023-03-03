return {
  name = "Build PMAS",
  builder = function ()
    return {
      cmd = {"cmake"},
      args = {"--build", "C:/Development/build-INR_DEV-User-PMAS-R", "--config", "Release", "--target", "all", "-j", "10", "--"},
      components = {{"on_output_quickfix", open_on_match = true, items_only = true}, "default"},
    }
  end
}

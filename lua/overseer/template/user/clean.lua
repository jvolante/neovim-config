return {
  name = "Clean",
  builder = function ()
    return {
      cmd = {"rm"},
      args = {"-rf", "build",},
      components = {"default"},
    }
  end
}

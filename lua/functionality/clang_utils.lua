local overseer = require('overseer')

local M = {
  configuration_presets = {},
  build_targets = {},
}

local settings = {
  build_dir = "build",
  targets_initialized = false,
}

local function read_config_presets ()
  local cmake_presets_file = vim.fn.finddir('CMakePresets.json', ';/.', 1)
  local f = io.open(cmake_presets_file, 'r')

  if f ~= nil then
    local success, presets = pcall(vim.json.decode, f:read("*a"))
    if success then
      M.configuration_presets = presets.configurePresets
      return presets.configurePresets
    else
      vim.notify("Error parsing CMakePresets file.", vim.log.levels.ERROR)
    end
  end
end

function M.setup (opts)
  require('utilities').table_update(settings, opts)
end

function M.on_cd ()
  setup_configure_tasks(M.configuration_presets)
end

function M.query_targets ()
  local cmd = "cmake --build " .. settings.build_dir .. " --target help"
  local job_id = vim.fn.jobstart(cmd,
      {stdout_buffered = true,
      on_stdout = function (text)
        vim.pretty_print(text)
        local target_pattern = '[%a%d\\-]*: phony$'
        for token in string.gmatch(text, '[^\n]+') do
          vim.pretty_print(token)
          local match = string.match(token, target_pattern)

          if match ~= nil then
            vim.pretty_print(match)
          end
        end
      end,})
end

-- overseer.register_template {
--   generator = function (search, cb)
--     local tasks = {}
--     for name, _ in ipairs(read_config_presets()) do
--       table.insert(tasks, {
--         name = "Configure " .. name,
--         builder = function (params)
--           return { cmd = "cmake --no-warn-unused-cli --preset " .. name .. " -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DGM_USE_UNITY_BUILD:STRING=OFF -H. -B" .. settings.build_dir .. " -G Ninja" }
--         end,
--         tags = { overseer.TAG.CONFIGURE },
--       })
--     end
--     cb(tasks)
--   end
-- }

return M

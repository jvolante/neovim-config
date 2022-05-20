local util = require('utilities')

-- This module implements the loading of settings files local to the user account
-- and local to a directory
M = {}

-- dictionary of keys that will be parsed from the user settings json
-- who's values are the functions that will be called on the values
-- from the json dictionary
M._settings_handlers = {
  indent = function(indent_length) util.setupIndent(indent_length, vim.o) end,
  o = function(osettings)
    for setting, value in pairs(osettings) do
      vim.o[setting] = value
    end
  end,

  g = function(gsettings)
    for setting, value in pairs(gsettings) do
      vim.g[setting] = value
    end
  end,
}

-- The default project settings table
M._default_project_settings = {
  indent = 2,
}

local function process_settings(settings)
  for key, value in pairs(settings) do
    local callback = M._settings_handlers[key]
    if callback ~= nil then
      callback(value)
    end
  end
end

local function process_default_project_settings()
  process_settings(M._default_project_settings)
end

-- Add a new handler to the list of settings handlers
--
-- @param key: The key of this setting in the json file
-- @param handler: The handler function of this key
-- @param default: The default setting for this key
function M.register_settings_handler(key, handler, default)
  if type(key) ~= "string" then
    error("key must be type(string) got " .. type(key))
  end

  if type(handler) ~= "function" then
    error("handler must be type(function) got " .. type(handler))
  end

  if M._settings_handlers[key] == nil then
    M._settings_handlers[key] = handler
    M._default_project_settings[key] = default
  else
    vim.schedule(function()
      print("Could not register handler " .. key .. " because it already exists")
    end)
  end
end

function M.setup(options)
  local defaults = {
    load_user_settings = true,
    load_project_settings = true,
    cache_settings = false,
  }

  options = options or defaults

  return M._setup(
    options.load_user_settings or defaults.load_user_settings,
    options.load_project_settings or defaults.load_project_settings,
    options.cache_settings or defaults.cache_settings)

end

function M._setup(load_user_settings, load_project_settings, cache_settings)
  if load_user_settings then
    local user_setup_fname = vim.env.HOME .. '/.nvimUserSettings.json'

    local f = io.open(user_setup_fname, 'r')

    if f ~= nil then
      local status, settings = pcall(vim.json.decode, f:read("*a"))

      -- If we have user local settings, update the defaults
      -- and process them
      if status then
        util.table_update(M._default_project_settings, settings)
        process_settings(settings)
      else
        vim.schedule(function()
          print(settings)
          print("User preferences not loaded")
        end)
      end
    else
      process_default_project_settings()
    end
  end

  if load_project_settings then
    -- load workspace local settings, ussually use this to set build tasks
    -- and indent options on a per project basis
    vim.api.nvim_create_autocmd("DirChanged", {
      pattern = { '*' },
      callback = function()
        -- find the project config folder
        local project_top_dir = vim.fn.finddir('.nvim', ';/.', 1)
        local dir_config_name = project_top_dir .. '/nvimProject.json'
        local f = io.open(dir_config_name, 'r')

        if f ~= nil then
          local status, settings = pcall(vim.json.decode, f:read("*a"))

          if status then
            process_settings(settings)
            return
          else
            vim.schedule(function()
              print(settings)
              print("Project preferences not loaded")
            end)
          end
        end

        -- If the file is not found, or we have an error parsing it
        -- load the default settings
        process_default_project_settings()
      end,
    })
  end
end

return M

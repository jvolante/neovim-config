local M = {}

function M.compose(f1, f2)
  return function(...) return f1(f2(...)) end
end

function M.isTable(x)
  return type(x) == 'table'
end

function M.setupIndent(tabstop, scope)
  scope.tabstop = tabstop
  scope.shiftwidth = tabstop
  scope.softtabstop = tabstop
  scope.expandtab = true

  -- Make the breakindent shift double the normal shift
  scope.breakindentopt = 'shift:' .. tostring(scope.tabstop * 2)
end

function M.table_update(table, table2)
  for key, val in ipairs(table2) do
    table[key] = val
  end
end

-- Remove spaces from the end of a string
function M.rstrip(st)
  return st:gsub('%s+$', "")
end

-- Remove spaces from the beginning of a string
function M.lstrip(st)
  return st:gsub('^%s+', "")
end

M.strip = M.compose(M.rstrip, M.lstrip)

-- Determine if we are in a Unix OS, HOME is generally blank in windows
-- but the vim environment will always set it
M.isUnix = vim.env.HOME == os.getenv("HOME")

-- Generic function to do error handling
-- reports error to the command line
-- @param f: function to call with possible error to catch
function M.error_wrap(f, ...)
  local ok, result = pcall(f, ...)
  if not ok then
    vim.notify(vim.inspect(result), vim.log.levels.ERROR)
  end
  return ok, result
end

function M.path_sep()
  return M.isUnix and "/" or "\\"
end

function M.find_containing_dir(name, isfile, search, count)
  local func = isfile and vim.fn.findfile or vim.fn.finddir
  local dirs = func(name, search, count)

  if count < 0 then
    if #dirs == 0 then
      return nil
    end

    local top_cmakelist = dirs[#dirs]

    -- get the directory of the top level CMakeLists.txt
    -- TODO inefficient find a way to do this with substr
    local split = vim.fn.split(top_cmakelist, M.path_sep(), true)
    if #split == 1 then
      return "."
    end
    table.remove(split, #split)
    local top_dir = vim.fn.join(split, M.path_sep())

    return top_dir
  else
    return dirs
  end
end

function M.lines(str)
  local result = {}
  for line in str:gmatch '[^\n]+' do
    table.insert(result, line)
  end
  return result
end

local parse_git_settings = "^(.*)=(.*)$"
M.git_settings = {}

function M.parse_git_settings()
  for k, v in pairs(M.git_settings) do
    M.git_settings[k] = nil
  end

  local handle = io.popen("git config --list")
  for line in handle:lines() do
    local key, val = line:match(parse_git_settings)
    if key ~= nil then
      M.git_settings[key] = val
    end
  end
end

vim.api.nvim_create_autocmd({"DirChanged", "VimEnter"}, {
  pattern = { "*" },
  callback = M.parse_git_settings,
})

function M.get_user_name()
  return M.git_settings["user.name"]
end

function M.get_user_email()
  return M.git_settings["user.email"] or ""
end

if vim.version().minor > 9 then
  M.num_cpus = vim.system({"nproc", "--all"}, { text = true })
else
  M.num_cpus = 8
end

function M.get_cpu_count()
  return tonumber(M.num_cpus:wait())
end

M.parse_git_settings()

function M.use_codeium()
  local v = os.getenv("USE_CODEIUM")
  return v ~= nil and #v ~= 0
end

return M
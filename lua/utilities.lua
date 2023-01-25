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
  local rstrip = '%s+$'
  return st:gsub(rstrip, "")
end

-- Remove spaces from the begining of a string
function M.lstrip(st)
  local lstrip = '^%s+'
  return st:gsub(lstrip, "")
end

M.strip = M.compose(M.rstrip, M.lstrip)

-- Determine if we are in a unix os, HOME is generally blank in windows
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

return M

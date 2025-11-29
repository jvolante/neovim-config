local M = {}

function M.compose(f1, f2)
  return function(...) return f1(f2(...)) end
end

function M.isTable(x)
  return type(x) == 'table'
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

M.num_cpus = vim.system({"nproc", "--all"}, { text = true })

function M.get_cpu_count()
  return tonumber(M.num_cpus:wait())
end


function M.use_codeium()
  local v = os.getenv("USE_CODEIUM")
  return v ~= nil and #v ~= 0
end

-- Generate GitHub link for the given file and line
function M.generate_github_link(file_path, line_number)
  -- Get the current file path relative to the git repo
  local repo_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local relative_path = file_path:gsub("^" .. vim.pesc(repo_root) .. "/", "")

  -- Get the current branch name
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

  -- Get the remote URL
  local remote_url = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")

  -- Transform git@ style URLs to https:// style
  local github_base_url
  if remote_url:match("^git@") then
    -- Convert git@github.com:user/repo.git to https://github.com/user/repo
    github_base_url = remote_url:gsub("^git@([^:]+):", "https://%1/")
    github_base_url = github_base_url:gsub("%.git$", "")
  else
    -- Handle https:// style URLs
    github_base_url = remote_url:gsub("%.git$", "")
  end

  -- Generate the GitHub link
  return github_base_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. line_number
end

-- Copy GitHub link to current file:line to clipboard
function M.copy_github_link()
  local file_path = vim.fn.expand("%:p")
  local line_number = vim.fn.line(".")

  local github_link = M.generate_github_link(file_path, line_number)

  -- Copy to clipboard
  vim.fn.setreg("+", github_link)
  vim.notify("GitHub link copied to clipboard: " .. github_link, vim.log.levels.INFO)
end

-- Convert degrees to radians
function M.deg_to_rad(degrees)
  return degrees * (math.pi / 180)
end

-- Convert radians to degrees
function M.rad_to_deg(radians)
  return radians * (180 / math.pi)
end

-- Get number under cursor, including scientific notation
-- Returns: number_str, number, start_pos, end_pos or nil if no number found
function M.get_number_under_cursor()
  local line = vim.fn.getline('.')
  local col = vim.fn.col('.')

  -- Match scientific notation or regular numbers
  -- This pattern matches: digits, decimal point, optional exponent (e/E followed by optional sign and digits)
  local before_pattern = '[%d%.eE%+%-]+$'
  local after_pattern = '^[%d%.eE%+%-]+'

  local before = line:sub(1, col - 1):match(before_pattern) or ''
  local after = line:sub(col):match(after_pattern) or ''
  local number_str = before .. after

  if number_str == '' then
    vim.notify('No number under cursor', vim.log.levels.WARN)
    return nil
  end

  local number = tonumber(number_str)
  if not number then
    vim.notify('Invalid number under cursor', vim.log.levels.WARN)
    return nil
  end

  local start_pos = col - #before
  local end_pos = col - 1 + #after

  return number_str, number, start_pos, end_pos
end

-- Convert the number under cursor from degrees to radians
function M.convert_deg_to_rad()
  local number_str, number, start_pos, end_pos = M.get_number_under_cursor()

  if not number then
    return
  end

  local radians = M.deg_to_rad(number)
  local radians_str = string.format('%.6f', radians)

  -- Replace the number under cursor with the converted value
  vim.api.nvim_buf_set_text(0, vim.fn.line('.') - 1, start_pos - 1, vim.fn.line('.') - 1, end_pos, {radians_str})
  vim.notify(string.format('%s° = %s rad', number_str, radians_str), vim.log.levels.INFO)
end

-- Paths and command for spell file generation.
M.spell_add_file = vim.fn.fnameescape(vim.fn.stdpath('config') .. '/spell/en.utf-8.add')
M.spell_spl_file = M.spell_add_file .. '.spl'
M.mkspell_cmd = "silent! mkspell! " .. M.spell_spl_file .. " " .. M.spell_add_file

return M
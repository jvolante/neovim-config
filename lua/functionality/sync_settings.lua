function set_git_url()
  local url = vim.input("Enter Git url to sync your config to")
  if url ~= nil then
    urlFile = assert(io.open(urlFileName))
    urlFile:write(url)
    urlFile:close()
  end

  return url
end

function get_git_url()
  local url

  local urlFileName = vim.env.CONFIG .. "settingsUrl"
  local urlFile = io.open(urlFileName, 'r')
  if urlFile ~= nil then 
    url = urlFile:read("*all")
    urlFile:close()
  else
    url = set_git_url()
  end

  return url
end

function pull_config()
end

function push_config()
end

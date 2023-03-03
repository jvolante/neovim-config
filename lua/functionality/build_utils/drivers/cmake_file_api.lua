CmakeFileAPI = {
  build_dir = '',
  query_dir = '',
  response_dir = '',
  targets = {},
}

function CmakeFileAPI:new(build_dir)
  if ~vim.fn.isdirectory(build_dir) then
    error('Not a directory: ' .. build_dir)
  end

  local o = {build_dir = build_dir}
  setmetatable(o, self)
  self.__index = self

  local api_dir = o.build_dir .. '/.cmake/api/v1/'
  o.query_dir = api_dir .. '/query'
  o.response_dir = api_dir .. '/response'
  return o
end

-- @description: Create the cmake file api query dir and add
-- the requrest for the code model
function CmakeFileAPI:_createQueryDir()
  vim.fn.mkdir(self.query_dir, 'p')
  vim.fn.writefile('', self.query_dir .. '/codemodel-v2')
end

function CmakeFileAPI:supportsTargets()
  return true
end

function CmakeFileAPI:parseTargets()
  local files = listfiles(response_dir)
end

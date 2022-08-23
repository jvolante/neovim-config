local autosave = require("auto-save")

autosave.setup {
  condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1 and
      fn.bufname(buf) ~= nil and
      #fn.bufname(buf) > 0 and
			utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
  debounce_delay = 1000
}


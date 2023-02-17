local M = {}

M.root_patterns = { ".git", "lua" }

---@param plugin string
function M.has(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

return M

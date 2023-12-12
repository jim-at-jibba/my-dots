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

M.declutter_terminal = function()
	require("lualine").hide()
	vim.cmd("silent !tmux set-option -g status off")
end

M.clutter_terminal = function()
	require("lualine").hide({ unhide = true })
	vim.cmd("silent !tmux set-option -g status on")
end

return M

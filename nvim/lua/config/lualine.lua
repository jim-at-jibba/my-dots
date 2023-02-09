local function clock()
	return " " .. os.date("%H:%M")
end

local function holidays()
	return "🎅🎄🌟🎁"
end

local function my_favs()
	return "🦄🐙"
end

local config = {
	options = {
		theme = "catpuccin", -- tokyonight nightfox rose-pine
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		icons_enabled = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			{ "diagnostics", sources = { "nvim_diagnostic" } },
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, symbols = { modified = "  ", readonly = "" } },
		},
		-- lualine_x = {
		-- 	{
		-- 		require("noice").api.status.message.get_hl,
		-- 		cond = require("noice").api.status.message.has,
		-- 	},
		-- },
		lualine_y = { "location" },
		lualine_z = { clock },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = { "nvim-tree" },
}

-- try to load matching lualine theme

local M = {}

function M.load()
	local name = vim.g.colors_name or ""
	local ok, _ = pcall(require, "lualine.themes." .. name)
	if ok then
		config.options.theme = name
	end
	require("lualine").setup(config)
end

M.load()

-- vim.api.nvim_exec([[
--   autocmd ColorScheme * lua require("config.lualine").load();
-- ]], false)

return M

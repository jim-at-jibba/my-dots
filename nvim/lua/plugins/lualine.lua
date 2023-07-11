return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
	config = function()
		-- local navic = require("nvim-navic")
		local function clock()
			return " " .. os.date("%H:%M")
		end

		local function holidays()
			return "🎅🎄🌟🎁"
		end

		local function my_favs()
			return "🦄🐙"
		end

		local signs = { error = " ", warn = " ", hint = " ", info = " " }
		local config = {
			options = {
				theme = "auto", -- tokyonight nightfox rose-pine
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				icons_enabled = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						diagnostics_color = {
							-- Same values as the general color option can be used here.
							error = "DiagnosticError", -- Changes diagnostics' error color.
							warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
							info = "DiagnosticInfo", -- Changes diagnostics' info color.
							hint = "DiagnosticHint", -- Changes diagnostics' hint color.
						},
						symbols = signs,
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ "filename", path = 1, symbols = { modified = "  ", readonly = "" } },
				},
				lualine_x = {},
				lualine_y = { "location" },
				lualine_z = { clock, my_favs },
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
	end,
}

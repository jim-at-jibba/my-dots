return {
	{
		"maxmx03/fluoromachine.nvim",
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = true,
				transparent = false,
				theme = "retrowave",
			})

			-- vim.cmd.colorscheme("fluoromachine")
		end,
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = true,
		config = function()
			require("tokyonight").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				light_style = "day", -- The theme is used when the background is set to light
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true, -- Disable setting background
					terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
					dim_inactive = false, -- Non focused panes set to alternative background
				},
			})
		end,
	},
	{
		"rose-pine/neovim",
		as = "rose-pine",
		lazy = true,
		config = function()
			require("rose-pine").setup({
				--- @usage 'auto'|'main'|'moon'|'dawn'
				variant = "auto",
				--- @usage 'main'|'moon'|'dawn'
				dark_variant = "moon",
				bold_vert_split = false,
				dim_nc_background = false,
				disable_background = true,
				disable_float_background = false,
				disable_italics = false,

				--- @usage string hex value or named color from rosepinetheme.com/palette
				groups = {
					background = "base",
					background_nc = "_experimental_nc",
					panel = "surface",
					panel_nc = "base",
					border = "highlight_med",
					comment = "muted",
					link = "iris",
					punctuation = "subtle",

					error = "love",
					hint = "iris",
					info = "foam",
					warn = "gold",

					headings = {
						h1 = "iris",
						h2 = "foam",
						h3 = "rose",
						h4 = "gold",
						h5 = "pine",
						h6 = "foam",
					},
					-- or set all headings at once
					-- headings = 'subtle'
				},

				-- Change specific vim highlight groups
				-- https://github.com/rose-pine/neovim/wiki/Recipes
				highlight_groups = {
					ColorColumn = { bg = "rose" },

					-- Blend colours against the "base" background
					CursorLine = { bg = "foam", blend = 10 },
					StatusLine = { fg = "love", bg = "love", blend = 10 },
				},
			})
		end,
	},
}

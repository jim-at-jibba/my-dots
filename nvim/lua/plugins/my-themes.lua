return {
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
				groups = {
					all = {
						ColorColumn = { bg = "palette.bg1" },

						-- Blend colours against the "base" background
						CursorLine = { bg = "bg2" },
						StatusLine = { fg = "pink", bg = "pink", blend = "10" },

						normalfloat = { bg = "bg2" },
						FloatBorder = { fg = "palette.bg2", bg = "palette.bg2" },
						FloatTitle = { bg = "palette.bg2" },

						TelescopeTitle = { fg = "pink", bold = "true" },
						TelescopePromptNormal = { bg = "bg2" },
						TelescopePromptBorder = { fg = "bg2", bg = "bg2" },
						TelescopeResultsNormal = { fg = "white", bg = "bg0" },
						TelescopeResultsBorder = { fg = "bg0", bg = "bg0" },
						TelescopePreviewNormal = { fg = "white", bg = "bg3" },
						TelescopePreviewBorder = { fg = "bg3", bg = "bg3" },

						NoiceCmdLinePrompt = { fg = "orange", bold = "true" },
						NoiceCmdlinePopup = { fg = "palette.magenta", bg = "palette.bg2" },
						NoiceCmdlinePopupBorder = { fg = "palette.bg2", bg = "palette.bg2" },
						NoiceMini = { fg = "orange", bg = "bg2" },
						-- NoiceLspProgressSpinner = { bg = colors.theme.ui.bg },
						-- NoiceLspProgressClient = { bg = colors.theme.ui.bg },
						-- NoiceLspProgressTitle = { bg = colors.theme.ui.bg },

						-- DiagnosticBorder = { fg = "surface", bg = "surface" },
						DiagnosticNormal = { bg = "bg2", fg = "bg2" },
						-- DiagnosticShowNormal = { fg = "surface", bg = "surface" },
						-- DiagnosticShowBorder = { bg = "surface" },
					},
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
				disable_background = false,
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

					FloatBorder = { fg = "surface", bg = "surface" },
					NormalFloat = { bg = "surface" },
					FloatTitle = { bg = "surface" },

					TelescopeTitle = { fg = "love", bold = true },
					TelescopePromptNormal = { bg = "surface" },
					TelescopePromptBorder = { fg = "surface", bg = "surface" },
					TelescopeResultsNormal = { fg = "text", bg = "nc" },
					TelescopeResultsBorder = { fg = "nc", bg = "nc" },
					TelescopePreviewNormal = { fg = "text", bg = "overlay" },
					TelescopePreviewBorder = { fg = "overlay", bg = "overlay" },

					NoiceCmdLinePrompt = { fg = "foam", bold = true },
					NoiceCmdlinePopup = { fg = "iris", bg = "nc" },
					NoiceCmdlinePopupBorder = { fg = "nc", bg = "nc" },

					-- -- TitleString = { fg = "rose", bg = "surface" },
					-- -- TitleIcon = { fg = "surface", bg = "surface" },
					-- DiagnosticBorder = { fg = "surface", bg = "surface" },
					-- DiagnosticNormal = { bg = "surface" },
					-- DiagnosticShowNormal = { fg = "surface", bg = "surface" },
					-- DiagnosticShowBorder = { bg = "surface" },
				},
			})
		end,
	},
}

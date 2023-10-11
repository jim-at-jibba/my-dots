return {
	"folke/noice.nvim",
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	config = function()
		local cmdline_opts = {}
		require("notify").setup({
			background_colour = "#000000",
			timeout = 500,
		})
		require("noice").setup({
			cmdline = {
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "", opts = cmdline_opts },
					search_down = {
						kind = "Search",
						pattern = "^/",
						icon = "🔎 ",
						ft = "regex",
						opts = cmdline_opts,
					},
					search_up = {
						kind = "Search",
						pattern = "^%?",
						icon = "🔎 ",
						ft = "regex",
						opts = cmdline_opts,
					},
					filter = { pattern = "^:%s*!", icon = "$", ft = "sh", opts = cmdline_opts },
					f_filter = {
						kind = "CmdLine",
						pattern = "^:%s*%%%s*!",
						icon = " $",
						ft = "sh",
						opts = cmdline_opts,
					},
					v_filter = {
						kind = "CmdLine",
						pattern = "^:%s*%'<,%'>%s*!",
						icon = " $",
						ft = "sh",
						opts = cmdline_opts,
					},
					lua = { pattern = "^:%s*lua%s+", icon = "", conceal = true, ft = "lua", opts = cmdline_opts },
					rename = {
						pattern = "^:%s*IncRename%s+",
						icon = " ",
						conceal = true,
						opts = {
							relative = "cursor",
							size = { min_width = 20 },
							position = { row = -3, col = 0 },
							buf_options = { filetype = "text" },
							border = {
								text = {
									top = " rename ",
								},
							},
						},
					},
				},
			},
			views = { split = { enter = true } },
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			messages = {
				-- NOTE: If you enable messages, then the cmdline is enabled automatically.
				-- This is a current Neovim limitation.
				enabled = true, -- enables the Noice messages UI
				view = "mini", -- default view for messages
				view_error = "mini", -- view for errors
				view_warn = "mini", -- view for warnings
				view_history = "messages", -- view for :messages
				view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
			},
			notify = {
				enabled = false,
				view = "notify",
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
	end,
}

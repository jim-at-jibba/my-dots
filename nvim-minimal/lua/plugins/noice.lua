local trace = vim.log.levels.TRACE
local routes = {
	-- redirect to popup
	{ filter = { min_height = 10 }, view = "popup" },

	-- write/deletion messages
	{ filter = { event = "msg_show", find = "%d+B written$" }, view = "mini" },
	{ filter = { event = "msg_show", find = "%d+L, %d+B$" }, view = "mini" },
	{ filter = { event = "msg_show", find = "%-%-No lines in buffer%-%-" }, view = "mini" },

	-- unneeded info on search patterns
	{ filter = { event = "msg_show", find = "^[/?]." }, skip = true },
	{ filter = { event = "msg_show", find = "^E486: Pattern not found" }, view = "mini" },

	-- Word added to spellfile via
	{ filter = { event = "msg_show", find = "^Word .*%.add$" }, view = "mini" },

	-- Diagnostics
	{
		filter = { event = "msg_show", find = "No more valid diagnostics to move to" },
		view = "mini",
	},

	-- :make
	{ filter = { event = "msg_show", find = "^:!make" }, skip = true },
	{ filter = { event = "msg_show", find = "^%(%d+ of %d+%):" }, skip = true },

	-----------------------------------------------------------------------------
	{ -- nvim-early-retirement
		filter = {
			event = "notify",
			cond = function(msg)
				return msg.opts and msg.opts.title == "Auto-Closing Buffer"
			end,
		},
		view = "mini",
	},

	-- nvim-treesitter
	{ filter = { event = "msg_show", find = "^%[nvim%-treesitter%]" }, view = "mini" },
	{ filter = { event = "notify", find = "All parsers are up%-to%-date" }, view = "mini" },

	-- Mason
	{ filter = { event = "notify", find = "%[mason%-tool%-installer%]" }, view = "mini" },
	{
		filter = {
			event = "notify",
			cond = function(msg)
				return msg.opts and msg.opts.title and msg.opts.title:find("mason.*.nvim")
			end,
		},
		view = "mini",
	},

	-- DAP
	{ filter = { event = "notify", find = "^Session terminated$" }, view = "mini" },
	-- LSP
	{
		filter = { event = "notify", find = "No information available" },
		view = "mini",
	},
}

return {
	{ -- Message & Command System Overhaul
		"folke/noice.nvim",
		event = "VeryLazy",
		enabled = true,
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		keys = {
			{
				"<Esc>",
				function()
					vim.cmd.Noice("dismiss")
				end,
				desc = "󰎟 Clear Notifications",
			},
			{
				"<leader>nh",
				function()
					vim.cmd.Noice("dismiss")
					vim.cmd.Noice("history")
				end,
				mode = { "n", "x", "i" },
				desc = "󰎟 Notification Log",
			},
		},
		opts = {
			routes = routes,
			cmdline = {
				view = "cmdline", -- cmdline|cmdline_popup
				format = {
					search_down = { icon = "  ", view = "cmdline" }, -- FIX needs to be set explicitly
					cmdline = { view = "cmdline_popup" },
					lua = { view = "cmdline_popup" },
					help = { view = "cmdline_popup" },
					numb = { -- numb.nvim
						pattern = "^:%d+$",
						view = "cmdline",
						conceal = false,
					},
					IncRename = {
						pattern = "^:IncRename ",
						icon = " ",
						conceal = true,
						view = "cmdline_popup",
						opts = {
							relative = "cursor",
							size = { width = 30 }, -- `max_width` does not work, so fixed value
							position = { row = -3, col = 0 },
						},
					},
					substitute = { -- :s as a standalone popup
						view = "cmdline_popup",
						pattern = { "^:%%? ?s[ /]", "^:'<,'> ?s[ /]" },
						icon = " ",
						conceal = true,
					},
				},
			},
			-- DOCS https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
			views = {
				-- cmdline_popup = {
				-- 	-- border = { style = u.borderStyle },
				-- },
				mini = {
					timeout = 3000,
					zindex = 10, -- lower, so it does not cover nvim-notify
					-- position = { col = "96%" }, -- to the left to avoid collision with scrollbar
				},
				hover = {
					size = { max_width = 80 },
					win_options = { scrolloff = 4 },
				},
				popup = {
					size = { width = 90, height = 25 },
					win_options = { scrolloff = 8 },
				},
				split = {
					enter = true,
					size = "45%",
					close = { keys = { "q", "<D-w>", "<D-0>" } },
					win_options = { scrolloff = 3 },
				},
			},
			commands = {
				-- options for `:Noice history`
				history = {
					view = "split",
					filter_opts = { reverse = true }, -- show newest entries first
					filter = {}, -- empty list = deactivate filter = include everything
					opts = {
						enter = true,
						-- https://github.com/folke/noice.nvim#-formatting
						format = { "{title} ", "{cmdline} ", "{message}" },
					},
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
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			lsp = {
				signature = {
					enabled = false,
				},
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
		},
	},
	{ -- Notifications
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>ln",
				function()
					local history = require("notify").history()
					if #history == 0 then
						vim.notify("No Notification in this session.", trace, { title = "nvim-notify" })
						return
					end
					local msg = history[#history].message
					vim.fn.setreg("+", msg)
					vim.notify("Last Notification copied.", trace, { title = "nvim-notify" })
				end,
				desc = "󰎟 Copy Last Notification",
			},
		},
		opts = {
			render = "wrapped-compact",
			top_down = false,
			max_width = 72, -- commit message max length
			minimum_width = 15,
			level = vim.log.levels.TRACE, -- minimum severity level
			timeout = 6000,
			stages = "slide", -- slide|fade
			icons = { DEBUG = "", ERROR = "", INFO = "", TRACE = "", WARN = "" },
			on_open = function(win)
				-- set borderstyle
				if not vim.api.nvim_win_is_valid(win) then
					return
				end
			end,
		},
	},
}

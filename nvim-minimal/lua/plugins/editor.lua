-- on attach for nvim-tree
local function on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
end

return {
	-- mini
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		"PatschD/zippy.nvim",
		keys = {
			{ "<leader>l", "<cmd>lua require('zippy').insert_print()<CR>", desc = "Add debug log" },
		},
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					-- default options: exact mode, multi window, all directions, with a backdrop
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					-- show labeled treesitter nodes around the cursor
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					-- jump to a remote location to execute the operator
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "n", "o", "x" },
				function()
					-- show labeled treesitter nodes around the search matches
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				names = true, -- "Name" codes like Blue
			})
		end,
	},
	{
		"windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
	},
	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
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
	},
	-- telescope
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>b", ":Telescope buffers preview=true<CR>", desc = "View Buffers (Telescope)" },
			{ "<leader>lg", ":Telescope live_grep<CR>", desc = "Live grep (Telescope)" },
			{ "<leader>f", ":Telescope live_grep preview=true<CR>", desc = "Search (Telescope)" },
			{ "<leader>dr", ":Telescope lsp_references<CR>", desc = "LSP References (Telescope)" },
			{ "<C-p>", ":Telescope git_files preview=true<CR>", desc = "Fuzzy search (Telescope)" },
			{ "<leader>g", ":Telescope git_status preview=true<CR>", desc = "Git status (Telescope)" },
		},
		config = function()
			local trouble = require("trouble.providers.telescope")
			require("telescope").setup({
				defaults = {
					prompt_prefix = "🦄 ",
					color_devicons = true,
					selection_caret = " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "descending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "bottom",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = { mirror = false },
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					winblend = 0,
					border = {},
					set_env = { ["COLORTERM"] = "truecolor" },
					file_sorter = require("telescope.sorters").get_fzy_sorter,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

					mappings = {
						i = {
							["<C-x>"] = false,
							["<C-q>"] = require("telescope.actions").send_to_qflist,
							["<c-t>"] = trouble.open_with_trouble,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							["jk"] = require("telescope.actions").close,
						},
						n = {
							["<c-t>"] = trouble.open_with_trouble,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							["jk"] = require("telescope.actions").close,
						},
					},
				},
				extensions = {
					fzf_native = {
						fuzzy = true,
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					tldr = {
						-- your config here, see below for options
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = "kyazdani42/nvim-web-devicons",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
		},
		config = function()
			require("trouble").setup({
				auto_open = false,
				auto_close = true,
				auto_preview = true,
				use_lsp_diagnostic_signs = false,
			})
		end,
	},
	{ "nvim-telescope/telescope-ui-select.nvim" },
	-- nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<leader><leader>1", ":NvimTreeToggle<CR>", desc = "Toggle NVIM tree", silent = true, remap = false },
			{ "<leader>r", ":NvimTreeRefresh<CR>", desc = "Refresh NVIM tree" },
		},
		event = "VeryLazy",
		config = function()
			require("nvim-tree").setup({
				on_attach = on_attach,
				disable_netrw = true,
				hijack_cursor = true,
				view = {
					side = "right",
					width = 40,
				},
				renderer = {
					indent_markers = { enable = true },
					group_empty = true,
					special_files = {},
					icons = {
						show = {
							git = true,
							folder = true,
							file = true,
							folder_arrow = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							git = {
								unstaged = "!",
								staged = "+",
								unmerged = "",
								renamed = "➜",
								untracked = "?",
								deleted = "",
								ignored = "◌",
							},
							folder = {
								arrow_open = "",
								arrow_closed = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
						},
					},
				},
				filters = { custom = { ".git/", "node_modules" } },
				actions = {
					open_file = {
						window_picker = {
							exclude = {
								filetype = {
									"packer",
								},
								buftype = { "nofile", "terminal", "help" },
							},
						},
					},
				},
			})
		end,
	},
	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		event = { "BufReadPost", "BufNewFile" },
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"javascript",
					"typescript",
					"markdown",
					"markdown_inline",
					"c",
					"lua",
					"rust",
					"python",
					"css",
					"html",
					"go",
					"gomod",
					"gosum",
					"toml",
				}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "v",
						node_decremental = "V",
						-- node_incremental = "grn",
						scope_incremental = "grc",
						-- node_decremental = "grm",
					},
				},
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = { "c" }, -- list of language that will be disabled
					additional_vim_regex_highlighting = { "markdown" },
				},
				-- refactor = {
				--   highlight_definitions = {
				--       enable = true
				--   }
				-- },
				autotag = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup()
		end,
	},
	-- which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		enabled = false,
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		config = function()
			-- Don't like showing which key all the time...
			-- So I disable it in visual mode and when yanking, deleting
			-- https://github.com/folke/which-key.nvim/issues/304
			local preset = require("which-key.plugins.presets")
			preset.operators["v"] = nil
			preset.operators["y"] = nil
			preset.operators["d"] = nil
			require("which-key").setup({
				window = {
					border = "single",
					position = "bottom",
					margin = { 1, 0, 1, 0.75 },
					padding = { 0, 0, 0, 0 },
					winblend = 0,
					zindex = 1000,
				},
				layout = {
					height = { min = 4, max = 25 },
					width = { min = 20, max = 70 },
					spacing = 3,
					align = "left",
				},
			})
		end,
	},
	-- harpoon
	{
		"ThePrimeagen/harpoon",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("harpoon").setup({
				tabline = false,
			})
		end,
		keys = {
			{ "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon menu" },
			{ "<leader>hj", "<cmd>lua require('harpoon.mark').add_file()<CR>", desc = "Add file to Harpoon" },
			{ "<leader>hk", "<cmd>lua require('harpoon.mark').delete_file()<CR>", desc = "Remove file from Harpoon" },
			{ "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", desc = "Navigate to file 1 in Harpoon" },
			{ "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", desc = "Navigate to file 2 in Harpoon" },
			{ "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", desc = "Navigate to file 3 in Harpoon" },
			{ "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", desc = "Navigate to file 4 in Harpoon" },
		},
	},
	--toggleterm
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		config = function()
			local toggleterm = require("toggleterm")
			toggleterm.setup({
				open_mapping = [[<c-\>]],
				shade_filetypes = { "none" },
				shade_terminals = true,
				shading_factor = "1",
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jj", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
			end

			-- if you only want these mappings for toggle term use term://*toggleterm#* instead
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			local Terminal = require("toggleterm.terminal").Terminal

			local pio_monitor = Terminal:new({
				cmd = "pio device monitor",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "double",
				},
				-- function to run on opening the terminal
				on_open = function(term)
					-- vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			function _pio_monitor_toggle()
				pio_monitor:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>pm",
				"<cmd>lua _pio_monitor_toggle()<CR>",
				{ noremap = true, silent = true }
			)

			local verticalTerm = Terminal:new({
				dir = "git_dir",
				direction = "vertical",
				float_opts = {
					border = "double",
				},
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function(term)
					vim.cmd("startinsert!")
				end,
			})

			function _vertical_toggle()
				verticalTerm:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>vt",
				"<cmd>lua _vertical_toggle()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},
	{
		"chrisgrieser/nvim-early-retirement",
		config = true,
		event = "VeryLazy",
	},
	{
		"smjonas/inc-rename.nvim",
		keys = {
			{ "<leader>rn", ":IncRename ", desc = "Incremental rename" },
		},
		config = function()
			require("inc_rename").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		enabled = false,
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						normal_hl = "Comment", -- Base highlight group in the notification window
						winblend = 0, -- Background color opacity in the notification window
						border = "none", -- Border around the notification window
						zindex = 45, -- Stacking priority of the notification window
						max_width = 0, -- Maximum width of the notification window
						max_height = 0, -- Maximum height of the notification window
						x_padding = 1, -- Padding from right edge of window boundary
						y_padding = 0, -- Padding from bottom edge of window boundary
						align = "bottom", -- Whether to bottom-align the notification window
						relative = "editor", -- What the notification window position is relative to
					},
				},
			})
		end,
	},
}

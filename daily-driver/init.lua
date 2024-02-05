vim.g.python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "~/.pyenv/versions/neovim3/bin/python3"
local api = vim.api

--[[======================================
-- Options START
--
--======================================]]
local options = {
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	smartindent = true,
	hlsearch = true,
	paste = false,
	number = true,
	hidden = true,
	errorbells = true,
	spell = false,
	splitbelow = true,
	splitright = true,
	relativenumber = true,
	nu = true,
	scrolloff = 8,
	completeopt = { "menu", "menuone", "noinsert", "noselect" },
	signcolumn = "yes",
	updatetime = 100,
	timeoutlen = 300,
	incsearch = true,
	showmode = true,
	foldenable = true,
	foldlevel = 99,
	foldlevelstart = 99,
	foldmethod = "indent",
	foldcolumn = "1",
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()",
	laststatus = 0,

	backup = false,
	writebackup = false,
	swapfile = false,
	termguicolors = true,
	cursorline = false,
	undodir = "/Users/jamesbest/.cache/nvim/undodir",
	-- laststatus = 0,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.g.vim_json_warnings = false

-- Options END

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

-- NOICE SETUP START

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
-- NOICE SETUP END

require("lazy").setup({
	-- ai start
	{
		"dustinblackman/oatmeal.nvim",
		cmd = { "Oatmeal" },
		keys = {
			{ "<leader>om", mode = "n", desc = "Start Oatmeal session" },
		},
		opts = {
			backend = "openai",
			model = "gpt-3.5-turbo",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					go = false,
					rust = false,
					elixir = false,
					["."] = true,
				},
				panel = {
					enabled = true,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-e>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},
	-- ai end
	-- cmp start
	{ "onsails/lspkind-nvim", dependencies = { "famiu/bufdelete.nvim" } },
	{
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			lspkind.init({
				symbol_map = {
					Boolean = "[] Boolean",
					Character = "[] Character",
					Class = "[] Class",
					Color = "[] Color",
					Constant = "[] Constant",
					Constructor = "[] Constructor",
					Enum = "[] Enum",
					EnumMember = "[] EnumMember",
					Event = "[ﳅ] Event",
					Field = "[] Field",
					File = "[] File",
					Folder = "[ﱮ] Folder",
					Function = "[ﬦ] Function",
					Interface = "[] Interface",
					Keyword = "[] Keyword",
					Method = "[] Method",
					Module = "[] Module",
					Number = "[] Number",
					Operator = "[Ψ] Operator",
					Parameter = "[] Parameter",
					Property = "[ﭬ] Property",
					Reference = "[] Reference",
					Snippet = "[] Snippet",
					String = "[] String",
					Struct = "[ﯟ] Struct",
					Text = "[] Text",
					TypeParameter = "[] TypeParameter",
					Unit = "[] Unit",
					Value = "[] Value",
					Variable = "[ﳛ] Variable",
					Copilot = "[]",
				},
			})

			cmp.setup({
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = -3,
						side_padding = 0,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, item)

						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
				experimental = { native_menu = false, ghost_text = false },
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					-- ["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 5 },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	-- luasnip
	{ "rafamadriz/friendly-snippets", event = "VeryLazy" },
	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		dependencies = "saadparwaiz1/cmp_luasnip",
		config = function()
			local ls = require("luasnip")
			local vsc = require("luasnip.loaders.from_vscode")
			local lua = require("luasnip.loaders.from_lua")

			ls.filetype_extend("javascript", { "html" })
			ls.filetype_extend("javascriptreact", { "html" })
			ls.filetype_extend("typescript", { "html" })
			ls.filetype_extend("typescriptreact", { "html" })
			ls.filetype_extend("htmldjango", { "html" })
			ls.filetype_extend("django-html", { "html" })
			ls.filetype_extend("python", { "django" })

			vsc.lazy_load()
			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })

			vim.keymap.set("i", "<c-h>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
	-- cmp end

	-- editor plugins start

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
	{ "nvim-telescope/telescope-ui-select.nvim" },
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
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader><leader>1", ":Neotree toggle show filesystem right<CR>", { silent = true })
			vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { silent = true })
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
	-- editor plugins end

	-- Languages START
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	-- conform
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "ruff", "black", "isort" },
					-- Use a sub-list to run only the first available formatter
					javascript = { { "prettierd", "prettier" } },
					typescript = { { "prettierd", "prettier" } },
					javascriptreact = { { "prettierd", "prettier" } },
					typescriptreact = { { "prettierd", "prettier" } },
					go = { "gofmt", "goimports" },
					elixir = { "mix" },
					-- ["*"] = { "typos" },
					-- ["_"] = { "typos" },
				},
			})
		end,
	},
	-- lint
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				javascript = { "eslint" },
				javascriptreact = { "eslint" },
				typescript = { "eslint" },
				typescriptreact = { "eslint" },
				lua = { "luacheck" },
			}
		end,
	},
	-- Languages END

	-- LSP START
	{ "folke/neodev.nvim", opts = {} },
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				opts = function(_, opts)
					vim.list_extend(opts.ensure_installed, {
						"delve",
						"gotests",
						"golangci-lint",
						"gofumpt",
						"goimports",
						"golangci-lint-langserver",
						"impl",
						"gomodifytags",
						"iferr",
						"gotestsum",
						"intelephense",
						"phpactor",
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>dd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to definition (LSP)" },
			{ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code action (LSP)" },
			-- { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename (LSP)" },
			{ "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show docs (LSP)" },
			{
				"<leader>dl",
				"<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>",
				desc = "Show live diagnostics (LSP)",
			},
			{
				"<leader>dn",
				"<cmd>lua vim.diagnostic.goto_next({ border = 'rounded', max_width = 100 })<CR>",
				desc = "Show live diagnostics (LSP)",
			},
			{
				"<leader>dp",
				"<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded', max_width = 100 })<CR>",
				desc = "Show live diagnostics (LSP)",
			},
		},
		config = function()
			local util = require("lspconfig/util")
			local nvim_lsp = require("lspconfig")
			local path = util.path
			local function get_python_path(workspace)
				-- Use activated virtualenv.
				if vim.env.VIRTUAL_ENV then
					return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
				end
				-- Find and use virtualenv in workspace directory.
				for _, pattern in ipairs({ "*", ".*" }) do
					local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
					if match ~= "" then
						return path.join(path.dirname(match), "bin", "python")
					end
				end
				-- Fallback to system Python.
				return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local clangd_capabilities = capabilities
			clangd_capabilities.textDocument.semanticHighlighting = true
			clangd_capabilities.offsetEncoding = "utf-8"

			local servers = {
				"typos_lsp",
				"gopls",
				"pyright",
				"prismals",
				"html",
				"cssls",
				"lua_ls",
				"yamlls",
				"jsonls",
				"marksman",
				"sqlls",
				"emmet_ls",
				"astro",
				"tailwindcss",
				"arduino_language_server",
				"clangd",
				"rust_analyzer",
				"golangci_lint_ls",
				"svelte",
				"dockerls",
				"graphql",
			}

			-- Use a loop to conveniently call 'setup' on multiple servers
			for _, lsp in ipairs(servers) do
				local lsp_capabilities
				if lsp == "clangd" then
					lsp_capabilities = clangd_capabilities
				else
					lsp_capabilities = capabilities
				end

				-- https://www.reddit.com/r/neovim/s/TgMwZpSVWj
				-- lsp_capabilities.didChangeWatchedFiles.dynamicRegistration = true

				nvim_lsp[lsp].setup({
					on_attach = function(client, bufnr)
						require("lsp_signature").on_attach({}, bufnr)
						-- disable formatting for LSP clients as this is handled by null-ls
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
						local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
						for type, icon in pairs(signs) do
							local hl = "DiagnosticSign" .. type
							vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
						end

						local config = {
							-- disable virtual text
							virtual_text = false,
							-- show signs
							signs = { active = signs },
							update_in_insert = false,
							underline = true,
							severity_sort = true,
						}
						vim.diagnostic.config(config)

						if client.server_capabilities.documentFormattingProvider then
							vim.cmd([[augroup Format]])
							vim.cmd([[autocmd! * <buffer>]])
							vim.cmd([[autocmd BufWritePost <buffer> lua require'lsp.formatting'.format()]])
							vim.cmd([[augroup END]])
						end

						-- if lsp == "tsserver" then
						-- 	require("nvim-lsp-ts-utils").setup({})
						-- end
					end,
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if
							not vim.loop.fs_stat(path .. "/.luarc.json")
							and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
						then
							client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
								Lua = {
									runtime = {
										-- Tell the language server which version of Lua you're using
										-- (most likely LuaJIT in the case of Neovim)
										version = "LuaJIT",
									},
									diagnostics = {
										enable = true,
										globals = { "vim", "describe", "love" },
										disable = { "lowercase-global" },
									},
									-- Make the server aware of Neovim runtime files
									workspace = {
										checkThirdParty = false,
										library = {
											vim.env.VIMRUNTIME,
											"${3rd}/love2d/library",
											-- "${3rd}/busted/library",
										},
										-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
										-- library = vim.api.nvim_get_runtime_file("", true)
									},
								},
							})

							client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						end
						return true
					end,
					before_init = function(_, config)
						if lsp == "pyright" then
							print(get_python_path(config.root_dir))
							config.settings.python.pythonPath = get_python_path(config.root_dir)
							config.settings.python.venvPath = "/Users/jamesbest/.pyenv/versions/"
							config.settings.python.venv = "breedr-api"
						end
					end,
					capabilities = lsp_capabilities,
					settings = {
						graphql = {
							filetypes = { "graphql", "javascript", "typescript", "typescriptreact", "javascriptreact" },
						},
						html = {
							filetypes = {
								"tmpl",
								"html",
								"javascript",
								"javascriptreact",
								"javascript.jsx",
								"typescript",
								"typescriptreact",
								"typescript.tsx",
								"svelte",
							},
						},
						emmet_ls = {
							filetypes = {
								"html",
								"typescriptreact",
								"javascriptreact",
								"css",
								"sass",
								"scss",
								"less",
								"svelte",
							},
							init_options = {
								html = {
									options = {
										-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
										["bem.enabled"] = true,
									},
								},
							},
						},
						golangci_lint_ls = {},
						typos_lsp = {
							cmd = { "typos-lsp" },
							filetypes = { "*" },
						},
						gopls = {
							analyses = {
								unusedparams = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							staticcheck = true,
							semanticTokens = true,
						},
						json = {
							format = { enabled = false },
							schemas = {
								{
									description = "ESLint config",
									fileMatch = { ".eslintrc.json", ".eslintrc" },
									url = "http://json.schemastore.org/eslintrc",
								},
								{
									description = "Package config",
									fileMatch = { "package.json" },
									url = "https://json.schemastore.org/package",
								},
								{
									description = "Packer config",
									fileMatch = { "packer.json" },
									url = "https://json.schemastore.org/packer",
								},
								{
									description = "Renovate config",
									fileMatch = {
										"renovate.json",
										"renovate.json5",
										".github/renovate.json",
										".github/renovate.json5",
										".renovaterc",
										".renovaterc.json",
									},
									url = "https://docs.renovatebot.com/renovate-schema",
								},
								{
									fileMatch = { "tsconfig*.json" },
									url = "https://json.schemastore.org/tsconfig.json",
								},
								{
									fileMatch = {
										".prettierrc",
										".prettierrc.json",
										"prettier.config.json",
									},
									url = "https://json.schemastore.org/prettierrc.json",
								},
								{
									description = "OpenApi config",
									fileMatch = { "*api*.json" },
									url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json",
								},
							},
						},
						lua_ls = {
							cmd = { "lua-language-server" },
							filetypes = { "lua" },
							runtime = {
								version = "LuaJIT",
								path = vim.split(package.path, ";"),
							},
							completion = { enable = true, callSnippet = "Both" },
							diagnostics = {
								enable = true,
								globals = { "vim", "describe" },
								disable = { "lowercase-global" },
							},
							-- Look into this https://github.com/LuaLS/lua-language-server/wiki/Configuration-File for LOVE
							-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
							workspace = {
								checkThirdParty = false,
								library = {
									vim.api.nvim_get_runtime_file("", true),
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
									[vim.fn.expand("/usr/share/awesome/lib")] = true,
								},
								-- adjust these two values if your performance is not optimal
								maxPreload = 2000,
								preloadFileSize = 1000,
							},
							telemetry = { enable = false },
						},
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								kubernetes = "*.yaml",
								["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
								["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
								["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
								["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
								["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
								["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
								["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
								["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
								["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
								["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
								["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
								["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
							},
							format = { enabled = false },
							validate = false, -- TODO: conflicts between Kubernetes resources and kustomization.yaml
							completion = true,
							hover = false,
						},
					},
					flags = { debounce_text_changes = 150 },
				})
			end

			vim.lsp.handlers["textDocument/hover"] = function(...)
				vim.lsp.with(vim.lsp.handlers.hover, {
					border = "rounded",
				})(...)
			end

			vim.lsp.handlers["textDocument/signatureHelp"] = function(...)
				vim.lsp.with(vim.lsp.handlers.signature_help, {
					border = "rounded",
				})(...)
			end
		end,
	},
	{ "jose-elias-alvarez/nvim-lsp-ts-utils" },
	-- LSP END

	-- THEMES START
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
					NoiceMini = { fg = "iris", bg = "overlay" },

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
	-- THEMES END
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
}, {
	defaults = { version = false },
	install = { colorscheme = { "rose-pine" } },
})

-- Vim mappings, see lua/config/which.lua for more mappings
local map = vim.keymap.set
local opts = { silent = true, noremap = true }
vim.cmd("set background=dark")
vim.cmd.colorscheme("rose-pine")

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

--General
map("i", "jj", "<Esc>", opts)
map("n", "H", "^", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "nzzzv", opts)
map("n", "L", "g_", opts)
-- map("n", "q", "<Nop>", opts)
map("n", "<Space>/", ":noh<cr>", opts)

map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)

-- map("n", "<C-J>", "<C-W><C-J>", opts)
-- map("n", "<C-K>", "<C-W><C-K>", opts)
map("n", "<C-H>", "<C-W><C-H>", opts)
map("n", "<C-L>", "<C-W><C-L>", opts)
map("n", "<leader>+", ":vertical resize +5", opts)
map("n", "<leader>-", ":vertical resize -5", opts)
map("i", "<C-n>", "<C-x><C-o>", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map({ "n", "v" }, "<leader>y", '"+y', opts)

map({ "n", "v" }, "K", ":m '<-2<CR>gv=gv", opts)
map({ "n", "v" }, "J", ":m '>+1<CR>gv=gv", opts)

map("v", "<leader>p", '"_dP', opts)

map("n", "Y", "y$", opts)
-- map("n", "<leader>6", "<c-^>", opts)
map("n", "<leader><leader>", "<c-^>", opts)

map("t", "<Esc>", "<C-\\><C-n>", opts)

map("n", "dw", "ciw", opts)
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
-- vim.cmd("cnoreabbrev Q q")

-- Autocommands START
--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank()",
	group = yankGrp,
})

-- go to last loc when opening a buffer
api.nvim_create_autocmd(
	"BufReadPost",
	{ command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Write file on focus lost
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	pattern = "*",
	command = "wa",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		vim.notify("⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms")
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
-- Autocommands END

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
	-- copilot
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
					enabled = false,
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
	-- mini
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
				namess = true, -- "Name" codes like Blue
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
	-- LSP
	{
		"rmagatti/goto-preview",
		keys = {
			{
				"<leader>dpd",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				desc = "Preview definition",
			},
			{
				"<leader>dpr",
				"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
				desc = "Preview definition",
			},
			{
				"<esc>",
				"<cmd>lua require('goto-preview').close_all_win()<CR>",
				desc = "Preview definition",
			},
		},
		config = function()
			require("goto-preview").setup({})
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
			{ "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename (LSP)" },
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
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local clangd_capabilities = capabilities
			clangd_capabilities.textDocument.semanticHighlighting = true
			clangd_capabilities.offsetEncoding = "utf-8"

			local servers = {
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
				"intelephense",
				"phpactor",
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
							workspace = {
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
	-- themes
	{
		"oxfist/night-owl.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd.colorscheme("night-owl")
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = true,
		event = "VeryLazy",
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
			{ "<leader>g", ":Telescope git_status preview=true<CR>", desc = "Git staus (Telescope)" },
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
			"JoosepAlviste/nvim-ts-context-commentstring",
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
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
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

			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
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

			function _lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>gs",
				"<cmd>lua _lazygit_toggle()<CR>",
				{ noremap = true, silent = true }
			)

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
		"folke/noice.nvim",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
		},
		event = "VeryLazy",
		config = function()
			local cmdline_opts = {}
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
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
}

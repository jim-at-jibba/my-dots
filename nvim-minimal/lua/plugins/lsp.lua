return {
	-- LSP
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
		"rmagatti/goto-preview",
		enabled = true,
		keys = {
			{
				"<leader>dD",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				desc = "Preview definition",
			},
			{
				"<leader>dR",
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
}

local nvim_lsp = require("lspconfig")
local map = vim.keymap.set
opts = { silent = true, noremap = true }

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local util = require("lspconfig/util")
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

-- local python_root_files = {
-- 	"WORKSPACE", -- added for Bazel; items below are from default config
-- 	"pyproject.toml",
-- 	"setup.py",
-- 	"setup.cfg",
-- 	"requirements.txt",
-- 	"Pipfile",
-- 	"pyrightconfig.json",
-- }
--
-- nvim_lsp.pyright.setup({
-- 	root_dir = nvim_lsp.util.root_pattern(unpack(python_root_files)),
-- 	on_attach = function(client)
-- 		-- disable formatting for LSP clients as this is handled by null-ls
-- 		client.server_capabilities.documentFormattingProvider = false
-- 		client.server_capabilities.documentRangeFormattingProvider = false
-- 		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- 		for type, icon in pairs(signs) do
-- 			local hl = "DiagnosticSign" .. type
-- 			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- 		end
-- 		vim.diagnostic.config({ virtual_text = false })
--
-- 		if client.server_capabilities.documentFormattingProvider then
-- 			vim.cmd([[augroup Format]])
-- 			vim.cmd([[autocmd! * <buffer>]])
-- 			vim.cmd([[autocmd BufWritePost <buffer> lua require'lsp.formatting'.format()]])
-- 			vim.cmd([[augroup END]])
-- 		end
--
-- 		map("n", "<leader>dd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- 		map("n", "<leader>d", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--
-- 		vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
-- 	end,
-- 	flags = {
-- 		debounce_text_changes = 200,
-- 	},
-- 	capabilities = capabilities,
-- })

local servers = {
	"gopls",
	"pyright",
	"prismals",
	"html",
	"cssls",
	"sumneko_lua",
	"tsserver",
	"yamlls",
	"jsonls",
	"marksman",
	"sqlls",
	"emmet_ls",
	"astro",
	"tailwindcss",
	"grammarly",
	-- "pylsp",
}

-- Use a loop to conveniently call 'setup' on multiple servers
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup({
		on_attach = function(client)
			-- disable formatting for LSP clients as this is handled by null-ls
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			vim.diagnostic.config({ virtual_text = false })

			if client.server_capabilities.documentFormattingProvider then
				vim.cmd([[augroup Format]])
				vim.cmd([[autocmd! * <buffer>]])
				vim.cmd([[autocmd BufWritePost <buffer> lua require'lsp.formatting'.format()]])
				vim.cmd([[augroup END]])
			end

			if lsp == "tsserver" then
				require("nvim-lsp-ts-utils").setup({})
			end

			map("n", "<leader>dd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
			map("n", "<leader>d", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

			vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
			-- diagnotics on hover - disabled in favor of lspsaga
			-- vim.api.nvim_create_autocmd("CursorHold", {
			-- 	buffer = bufnr,
			-- 	callback = function()
			-- 		local opts = {
			-- 			focusable = false,
			-- 			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			-- 			border = "rounded",
			-- 			source = "always",
			-- 			prefix = " ",
			-- 			scope = "cursor",
			-- 		}
			-- 		vim.diagnostic.open_float(nil, opts)
			-- 	end,
			-- })
		end,
		before_init = function(_, config)
			if lsp == "pyright" then
				config.settings.python.pythonPath = get_python_path(config.root_dir)
			end
		end,
		capabilities = capabilities,
		settings = {
			html = {
				filetypes = {
					"html",
					"tmpl",
				},
			},
			grammarly = {
				filetypes = { "markdown", "text" },
				init_options = {
					clientId = "clientId=client_2zkt1YpZ613xS1H6m68nsE",
				},
			},
			emmet_ls = {
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
				init_options = {
					html = {
						options = {
							-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
							["bem.enabled"] = true,
						},
					},
				},
			},
			gopls = { analyses = { unusedparams = true }, staticcheck = true },
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
			Lua = {
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

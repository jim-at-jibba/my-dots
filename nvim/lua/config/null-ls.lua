local nls = require("null-ls")
nls.setup({
	sources = {
		nls.builtins.code_actions.gitsigns,
		nls.builtins.code_actions.eslint,
		nls.builtins.diagnostics.eslint,
		nls.builtins.diagnostics.golangci_lint,
		nls.builtins.formatting.stylua,
		nls.builtins.formatting.goimports,
		nls.builtins.formatting.gofmt,
		nls.builtins.formatting.prettier.with({
			extra_args = { "--single-quote", "false" },
		}),
		nls.builtins.formatting.autopep8,
		nls.builtins.formatting.isort,
		nls.builtins.formatting.black,
		nls.builtins.diagnostics.flake8,
		-- nls.builtins.diagnostics.mypy,
	},
	on_attach = function(client)
		if client.server_capabilities.document_formatting then
			-- auto format on save (not asynchronous)
			local LspFormattingGrp = vim.api.nvim_create_augroup("LspFormattingGrp", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				command = "lua vim.lsp.buf.formatting_sync()",
				group = LspFormattingGrp,
			})
		end
	end,
})

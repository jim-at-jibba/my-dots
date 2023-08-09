return {
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
}

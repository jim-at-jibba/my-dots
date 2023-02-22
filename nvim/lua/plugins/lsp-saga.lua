return {
	"glepnir/lspsaga.nvim",
	event = "BufRead",
	config = function()
		require("lspsaga").setup({})
	end,
	keys = {
		{ "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "LspSaga Code action" },
		{ "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "LspSaga Line Diagnositics" },
		{ "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "LspSaga Next Diagnositics" },
		{ "<leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "LspSaga Prev Diagnositics" },
		{ "<leader>gh", "<cmd>Lspsaga hover_doc<CR>", desc = "LspSaga Hover doc" },
		{ "<leader>rn", "<cmd>Lspsaga rename<CR>", desc = "LspSaga Rename" },
		{ "<leader>dr", "<cmd>Lspsaga lsp_finder<CR>", desc = "LspSaga Finder" },
		{ "<leader>dd", "<cmd>Lspsaga goto_definition<CR>", desc = "LspSaga Goto definition" },
		{ "<leader>dp", "<cmd>Lspsaga peek_definition<CR>", desc = "LspSaga Peek definition" },
	},
	dependencies = {
		--Please make sure you install markdown and markdown_inline parser
		{ "nvim-treesitter/nvim-treesitter" },
	},
}

return {
	{
		"uga-rosa/ccc.nvim",
		opts = {},
		cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
		keys = {
			{ "<leader>zp", "<cmd>CccPick<cr>", desc = "Pick" },
			{ "<leader>zc", "<cmd>CccConvert<cr>", desc = "Convert" },
			{ "<leader>zh", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
		},
	},
}

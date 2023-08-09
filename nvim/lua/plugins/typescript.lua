return {
	{
		"dmmulroy/tsc.nvim",
		event = "VeryLazy",
		config = function()
			require("tsc").setup()
		end,
	},
}

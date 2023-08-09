return {
	{
		"preservim/vim-markdown",
		event = "VeryLazy",
		requires = { "godlygeek/tabular" },
	},
	{
		"iamcco/markdown-preview.nvim",
		event = "VeryLazy",
		build = "cd app && npm install",
		ft = { "markdown", "md" },
	},
}

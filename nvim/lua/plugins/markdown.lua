return {
	{
		"preservim/vim-markdown",
		requires = { "godlygeek/tabular" },
	},
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		ft = { "markdown", "md" },
	},
}

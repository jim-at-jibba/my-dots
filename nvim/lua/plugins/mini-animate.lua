return {
	-- animations
	{
		"echasnovski/mini.animate",
		enabled = false,
		event = "VeryLazy",
		config = function()
			require("mini.animate").setup()
		end,
	},
}

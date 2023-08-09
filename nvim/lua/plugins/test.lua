return {
	{
		"rcarriga/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"rcarriga/neotest-vim-test",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
			"rouge8/neotest-rust",
		},
		event = "VeryLazy",
		config = function()
			require("neotest").setup({
				status = { virtual_text = true },
				output = { open_on_run = true },
				quickfix = {
					open = function()
						vim.cmd("Trouble quickfix")
					end,
				},
				adapters = {
					require("neotest-python"),
					require("neotest-rust"),
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
						args = { "-count=1", "-timeout=60s" },
					}),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
				},
			})
		end,
	},
}

return {

	{
		"vim-test/vim-test",
		config = function()
			vim.g["test#strategy"] = "neovim"
			vim.g["test#neovim#term_position"] = "vertical"
		end,
	},
	{
		"rcarriga/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"rcarriga/neotest-vim-test",
			"nvim-neotest/neotest-python",
			-- "haydenmeade/neotest-jest",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python"),
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
						args = { "-count=1", "-timeout=60s" },
					}),
					-- require("neotest-jest")({
					-- 	jestCommand = "npm test --",
					-- 	jestConfigFile = "jest.config.ts",
					-- 	env = { CI = true },
					-- 	cwd = function(path)
					-- 		return vim.fn.getcwd()
					-- 	end,
					-- }),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
				},
			})
		end,
	},
}

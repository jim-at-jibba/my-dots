local status_ok, neotest = pcall(require, "neotest")

if not status_ok then
	return
end

neotest.setup({
	adapters = {
		require("neotest-python"),
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

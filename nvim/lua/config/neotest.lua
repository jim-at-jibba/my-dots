local status_ok, neotest = pcall(require, "neotest")

if not status_ok then
	return
end

neotest.setup({
	adapters = {
		require("neotest-python"),
		require("neotest-jest")({
			jestCommand = "npm test --",
		}),
		require("neotest-vim-test")({
			ignore_file_types = { "python", "vim", "lua" },
		}),
	},
})

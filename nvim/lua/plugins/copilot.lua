return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				go = false,
				rust = false,
				elixir = false,
				["."] = true,
			},
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = true, -- I am using cmp
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<C-e>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
		})
	end,
}

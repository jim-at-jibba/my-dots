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
				["."] = false,
			},
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false, -- I am using cmp
				auto_trigger = false,
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

local status_ok, gitsigns = pcall(require, "pomodoro")

if not status_ok then
	return
end

gitsigns.setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = {
			hl = "GitSignsChange",
			text = "▍",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
		delete = {
			hl = "GitSignsDelete",
			text = "▸",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		topdelete = {
			hl = "GitSignsDelete",
			text = "▾",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
		},
		changedelete = {
			hl = "GitSignsChange",
			text = "▍",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
		},
	},
	keymaps = {
		-- Default keymap options
		noremap = true,
		buffer = true,
		["n <CR>"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
		["n <backspace>"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
		["n <leader>ghs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		["n <leader>ghu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
		["n <leader>ghr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		["n <leader>ghR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
		["n <leader>ghp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
		["n <leader>gd"] = '<cmd>lua require"gitsigns".diff_this()<CR>',
		-- Text objects
		["o ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
		["x ih"] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
	},
})

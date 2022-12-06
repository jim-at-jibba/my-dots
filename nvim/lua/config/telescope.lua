local status_ok, telescope = pcall(require, "telescope")

if not status_ok then
	return
end

local actions = require("telescope.actions")
local trouble_status_ok, trouble = pcall(require, "trouble.providers.telescope")

if not trouble_status_ok then
	return
end

telescope.setup({
	defaults = {
		prompt_prefix = "🦄 ",
		color_devicons = true,
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "bottom",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = { mirror = false },
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		winblend = 0,
		border = {},
		set_env = { ["COLORTERM"] = "truecolor" },
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

		mappings = {
			i = {
				["<C-x>"] = false,
				["<C-q>"] = actions.send_to_qflist,
				["<c-t>"] = trouble.open_with_trouble,
			},
			n = { ["<c-t>"] = trouble.open_with_trouble },
		},
	},
	extensions = {
		fzf_native = {
			fuzzy = true,
			override_generic_sorter = false,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("noice")
telescope.load_extension("tailiscope")

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
		-- TEMP FIX: https://github.com/nvim-telescope/telescope.nvim/issues/484
		set_env = { ["COLORTERM"] = "truecolor" },
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		prompt_prefix = "🦄 ",
		color_devicons = true,
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "descending",
		layout_strategy = "horizontal",
		layout_config = {
			width = 0.75,
			prompt_position = "bottom",
			preview_cutoff = 120,
			horizontal = { mirror = false },
			vertical = { mirror = false },
		},
		winblend = 0,
		border = {},
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

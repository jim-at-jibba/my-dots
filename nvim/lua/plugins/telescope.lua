local pickers = require("telescope.pickers")
local Path = require("plenary.path")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local os_sep = Path.path.sep
local scan = require("plenary.scandir")

local live_grep_filters = {
	---@type nil|string
	extension = nil,
	---@type nil|string[]
	directories = nil,
}

local function run_live_grep(current_input)
	require("telescope.builtin").live_grep({
		additional_args = live_grep_filters.extension and function()
			return { "-g", "*." .. live_grep_filters.extension }
		end,
		search_dirs = live_grep_filters.directories,
		-- default_text = current_input,
	})
end

-- or create your custom action
local custom_actions = transform_mod({
	set_extension = function(prompt_bufnr)
		local current_input = action_state.get_current_line()
		vim.ui.input({ prompt = "*." }, function(input)
			if input == nil then
				return
			end
			live_grep_filters.extension = input
			actions.close(prompt_bufnr)
			run_live_grep(current_input)
		end)
	end,

	set_folders = function(prompt_bufnr)
		local current_input = action_state.get_current_line()
		local data = {}
		scan.scan_dir(vim.loop.cwd(), {
			hidden = true,
			only_dirs = true,
			respect_gitignore = true,
			on_insert = function(entry)
				table.insert(data, entry .. os_sep)
			end,
		})
		table.insert(data, 1, "." .. os_sep)
		actions.close(prompt_bufnr)
		pickers
			.new({}, {
				prompt_title = "Folders for Live Grep",
				finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file({}) }),
				previewer = conf.file_previewer({}),
				sorter = conf.file_sorter({}),
				attach_mappings = function(bufnr)
					action_set.select:replace(function()
						local current_picker = action_state.get_current_picker(bufnr)

						local dirs = {}
						local selections = current_picker:get_multi_selection()
						if vim.tbl_isempty(selections) then
							table.insert(dirs, action_state.get_selected_entry().value)
						else
							for _, selection in ipairs(selections) do
								table.insert(dirs, selection.value)
							end
						end
						live_grep_filters.directories = dirs
						actions.close(bufnr)
						run_live_grep(current_input)
					end)
					return true
				end,
			})
			:find()
	end,
})

return {
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = function()
			local trouble = require("trouble.providers.telescope")
			require("telescope").setup({
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
							["<C-q>"] = require("telescope.actions").send_to_qflist,
							["<c-t>"] = trouble.open_with_trouble,
						},
						n = { ["<c-t>"] = trouble.open_with_trouble },
					},
				},
				pickers = {

					live_grep = {
						mappings = {
							i = {
								["<c-f>"] = custom_actions.set_extension,
								["<c-l>"] = custom_actions.set_folders,
							},
						},
					},
				},
				extensions = {
					fzf_native = {
						fuzzy = true,
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					tldr = {
						-- your config here, see below for options
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("noice")
			require("telescope").load_extension("ui-select")
		end,
	},
}

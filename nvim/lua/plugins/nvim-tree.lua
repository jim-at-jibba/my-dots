return {
	"nvim-tree/nvim-tree.lua",
	keys = {
		{ "<leader><leader>1", ":NvimTreeToggle<CR>", desc = "Toggle NVIM tree" },
		{ "<leader>r", ":NvimTreeRefresh<CR>", desc = "Refresh NVIM tree" },
	},
	config = function()
		local nvim_tree_config = require("nvim-tree.config")
		local tree_cb = nvim_tree_config.nvim_tree_callback
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_cursor = true,
			view = {
				hide_root_folder = true,
				side = "right",
				width = 40,
				mappings = {
					list = {
						{ key = "s", cb = tree_cb("vsplit") },
						{ key = "z", cb = tree_cb("") },
						{ key = "m", cb = tree_cb("") },
					},
				},
			},
			renderer = {
				indent_markers = { enable = true },
				group_empty = true,
				special_files = {},
				icons = {
					show = {
						git = true,
						folder = true,
						file = true,
						folder_arrow = true,
					},
					glyphs = {
						default = "",
						symlink = "",
						git = {
							unstaged = "!",
							staged = "+",
							unmerged = "",
							renamed = "➜",
							untracked = "?",
							deleted = "",
							ignored = "◌",
						},
						folder = {
							arrow_open = "",
							arrow_closed = "",
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
					},
				},
			},
			filters = { custom = { ".git/", "node_modules" } },
			actions = {
				open_file = {
					window_picker = {
						exclude = {
							filetype = {
								"packer",
							},
							buftype = { "nofile", "terminal", "help" },
						},
					},
				},
			},
		})
	end,
}

return {

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"help",
					"javascript",
					"typescript",
					"c",
					"lua",
					"rust",
					"python",
					"css",
					"html",
					"go",
					"gomod",
					"gosum",
					"toml",
				}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
				indent = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = { "c", "rust" }, -- list of language that will be disabled
				},
				-- refactor = {
				--   highlight_definitions = {
				--       enable = true
				--   }
				-- },
				rainbow = {
					enable = true,
					-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
					extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = nil, -- Do not enable for files with more than n lines, int
					-- colors = {}, -- table of hex strings
					-- termcolors = {} -- table of colour name strings
				},
				autotag = {
					enable = true,
				},
				matchup = {
					enable = true, -- mandatory, false will disable the whole extension
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup()
		end,
	},
}

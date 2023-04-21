return {
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "danielvolchek/tailiscope.nvim" },
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = true,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring()
					end,
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			require("mini.indentscope").setup({
				options = {
					try_as_border = true,
				},
			})
		end,
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},
	{
		"ggandor/flit.nvim",
		keys = function()
			---@type LazyKeys[]
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{ "szw/vim-maximizer" },
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"crispgm/nvim-go",
		config = function()
			require("go").setup({
				notify = true,
				auto_lint = false,
				lint_prompt_style = "ql",
			})
		end,
	},
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},
	{
		"PatschD/zippy.nvim",
		keys = {
			{ "<leader>l", "<cmd>lua require('zippy').insert_print()<CR>", desc = "Add debug log" },
		},
	},
	{ "mbbill/undotree" },
	{
		"lukas-reineke/indent-blankline.nvim",
		ft = { "python", "yml", "yaml" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("indent_blankline").setup({
				char = "│",
				filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
				show_trailing_blankline_indent = false,
				show_current_context = false,
			})
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				namess = true, -- "Name" codes like Blue
			})
		end,
	},
	{
		"windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
	},
	-- references
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = { delay = 200 },
		config = function(_, opts)
			require("illuminate").configure(opts)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
					pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
				end,
			})
		end,
        -- stylua: ignore
        keys = {
            { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
            { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
        },
	},

	-- buffer remove
	{
		"echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
	},
	{
		"SmiteshP/nvim-navic",
		enable = false,
		dependencies = "neovim/nvim-lspconfig",
	},
	{
		"mrjones2014/tldr.nvim",
		dependencies = "nvim-telescope/telescope.nvim",
	},
	{
		"dstein64/vim-startuptime",
	},
}

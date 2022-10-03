local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_config(name)
	return string.format('require("config/%s")', name)
end

-- bootstrap packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
end

-- initialize and configure packer
local status_ok, packer = pcall(require, "packer")

if not status_ok then
	return
end

packer.init({
	enable = true, -- enable profiling via :PackerCompile profile=true
	threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
	max_jobs = 10,
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end,
	},
})

packer.startup(function(use)
	-- actual plugins list
	use("wbthomason/packer.nvim")
	use("lewis6991/impatient.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = get_config("telescope"),
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = get_config("treesitter"),
	})
	use({
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup()
		end,
	})

	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = get_config("gitsigns"),
	})
	use({ "kdheepak/lazygit.nvim" })
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({
		"akinsho/git-conflict.nvim",
		tag = "*",
		config = function()
			require("git-conflict").setup()
		end,
	})

	-- File nav
	use({
		"romgrk/barbar.nvim",
		config = get_config("barbar"),
	})
	use({
		"kyazdani42/nvim-tree.lua",
		config = get_config("nvim-tree"),
	})

	-- test
	use({
		"vim-test/vim-test",
		config = get_config("vim-test"),
	})
	use({
		"rcarriga/neotest",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"rcarriga/neotest-vim-test",
			"nvim-neotest/neotest-python",
			"haydenmeade/neotest-jest",
		},
		config = get_config("neotest"),
	})

	-- snippets
	use({ "rafamadriz/friendly-snippets" })
	use({
		"L3MON4D3/LuaSnip",
		requires = "saadparwaiz1/cmp_luasnip",
		config = get_config("luasnip"),
	})

	-- completion
	use({ "onsails/lspkind-nvim", requires = { "famiu/bufdelete.nvim" } })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-emoji" },
			-- { "hrsh7th/cmp-copilot" },
		},
		config = get_config("cmp"),
	})

	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = get_config("colorizer"),
	})

	use({ "p00f/nvim-ts-rainbow" })

	-- themes
	use({
		"rose-pine/neovim",
		config = get_config("rose-pine"),
	})
	use("B4mbus/oxocarbon-lua.nvim")
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = get_config("catppuccin"),
	})
	use("EdenEast/nightfox.nvim")
	use("folke/tokyonight.nvim")
	use({
		"olivercederborg/poimandres.nvim",
		config = function()
			require("poimandres").setup({
				disable_background = true,
				-- leave this setup function empty for default config
				-- or refer to the configuration section
				-- for configuration options
			})
		end,
	})

	-- utils
	use({ "rcarriga/nvim-notify", config = get_config("notify") })
	use({ "folke/which-key.nvim", config = get_config("which") })
	use({
		"wthollingsworth/pomodoro.nvim",
		requires = "MunifTanjim/nui.nvim",
		config = get_config("pomodoro"),
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		ft = { "python", "yml", "yaml" },
		config = get_config("indent-line"),
	})
	use({
		"Djancyp/cheat-sheet",
	})
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = get_config("trouble"),
	})
	use({ "nvim-pack/nvim-spectre", requires = "nvim-lua/plenary.nvim" })
	use({ "cohama/lexima.vim" })
	use({ "szw/vim-maximizer" })
	use({
		"windwp/nvim-ts-autotag",
		config = get_config("vim-test"),
	})
	use({
		"folke/todo-comments.nvim",
		config = get_config("todo-comments"),
	})
	use({
		"karb94/neoscroll.nvim",
		config = get_config("neoscroll"),
	})
	use({
		"luukvbaal/stabilize.nvim",
		config = get_config("stabilize"),
	})
	use({
		"numToStr/Comment.nvim",
		config = get_config("comment"),
	})
	use({
		"nvim-lualine/lualine.nvim",
		config = get_config("lualine"),
		event = "VimEnter",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({ "github/copilot.vim", config = get_config("copilot") })

	-- lsp
	use({ "neovim/nvim-lspconfig", config = get_config("lsp") })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })
	use({
		"ray-x/lsp_signature.nvim",
		require = { "neovim/nvim-lspconfig" },
		config = get_config("lsp-signature"),
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = get_config("null-ls"),
	})
	use({
		"cseickel/diagnostic-window.nvim",
		requires = { "MunifTanjim/nui.nvim" },
	})

	-- dap
	use({
		"mfussenegger/nvim-dap",
		config = get_config("dap"),
	})
	use({
		"leoluz/nvim-dap-go",
		config = get_config("dap-go"),
	})
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use({
		"theHamsta/nvim-dap-virtual-text",
		config = get_config("dap-virt"),
	})

	-- Notes
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
end)

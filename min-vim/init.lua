vim.g.python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "~/.pyenv/versions/neovim3/bin/python3"
-- All non plugin related (vim) options
-- require("options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

-- require("utils")

require("lazy").setup({

	-- {
	-- 	dir = "~/code/other/nvim-redraft/",
	-- 	config = function()
	-- 		require("nvim-redraft").setup({
	-- 			llm = {
	-- 				models = {
	-- 					{ provider = "openai", model = "gpt-4o-mini", label = "GPT-4o Mini" },
	-- 				},
	-- 				default_model_index = 1,
	-- 			},
	-- 		})
	-- 	end,
	-- 	build = "cd ts && npm install && npm run build",
	-- },
	{
		"jim-at-jibba/nvim-redraft",
		config = function()
			require("nvim-redraft").setup({
				-- Optional configuration
				system_prompt = "You are a code editing assistant...",
				keybindings = {
					visual_edit = "<leader>ae",
				},
			})
		end,
		build = "cd ts && npm install && npm run build",
	},
}, {
	defaults = { version = false },
	install = { colorscheme = { "terafox" } },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
-- Vim mappings, see lua/config/which.lua for more mappings
-- require("mappings")
-- Vim autocommands/autogroups
-- require("autocmd")

-- require("color")

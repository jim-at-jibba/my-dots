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
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
    },
})

packer.startup(function(use)
	-- actual plugins list
	use("wbthomason/packer.nvim")

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
		config = get_config("telescope"),
	})
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    
    use({ 
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
		config = get_config("trouble"),
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = get_config("treesitter"),
    })

    use({
		"nvim-lualine/lualine.nvim",
		config = get_config("lualine"),
		event = "VimEnter",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

    use({ 
        "wthollingsworth/pomodoro.nvim",
        requires = "MunifTanjim/nui.nvim",
		config = get_config("pomodoro"),
    })

    use({ 
        "SmiteshP/nvim-gps",
		config = get_config("pomodoro"),
    })

    use({ 
        "lewis6991/gitsigns.nvim",
		config = get_config("gitsigns"),
    })

    use({ 
        "kdheepak/lazygit.nvim",
    })

    use ({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

    use({"cohama/lexima.vim"})

    use ({
        "romgrk/barbar.nvim",
		config = get_config("barbar"),
      })

    use({"TaDaa/vimade"})

    use({
        "tami5/lspsaga.nvim",
		config = get_config("lspsaga"),
    })
end)
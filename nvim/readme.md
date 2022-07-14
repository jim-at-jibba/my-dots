## Neovim

### Removed plugins

```
use({
    "nvim-lualine/lualine.nvim",
    config = get_config("lualine"),
    event = "VimEnter",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

use("TaDaa/vimade")


	use({
		"goolord/alpha-nvim",
		config = get_config("alpha"),
	})

	use({
		"Mofiqul/trld.nvim",
		config = function()
			require("trld").setup()
		end,
	})
```



## Neovim

### Removed plugins

```

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



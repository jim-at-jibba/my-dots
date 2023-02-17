return {
		"folke/trouble.nvim",
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
      require('trouble').setup({
        auto_open = false,
        auto_close = true,
        auto_preview = true,
        use_lsp_diagnostic_signs = false,
      })
    end
  }


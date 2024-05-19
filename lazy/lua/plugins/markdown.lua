return {
  {
    "MeanderingProgrammer/markdown.nvim",
    event = "VeryLazy",
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({})
    end,
  },
}

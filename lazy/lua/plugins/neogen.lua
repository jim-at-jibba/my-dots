return {
  {
    "danymat/neogen",
    event = "VeryLazy",
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
      })
    end,
    keys = {
      {
        "<leader>nf",
        function()
          require("neogen").generate()
        end,
        desc = "Create neogen snippet",
      },
    },
  },
}

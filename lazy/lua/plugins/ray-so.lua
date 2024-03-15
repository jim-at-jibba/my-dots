return {
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    event = "VeryLazy",
    config = function()
      require("rayso").setup({
        options = {
          background = true,
          dark_mode = true,
          padding = 32,
          theme = "falcon",
        },
      })
    end,
  },
}

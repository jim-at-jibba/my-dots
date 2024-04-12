return {
  {
    "ptdewey/yankbank-nvim",
    config = function()
      require("yankbank").setup()
    end,
    keys = {
      { "<leader>y", "<cmd>YankBank<CR>", desc = "Open YankBank" },
    },
  },
}

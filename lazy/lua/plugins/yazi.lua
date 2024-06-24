return {
  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },

    keys = {
      { "<leader><leader>1", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
    },
  },
}

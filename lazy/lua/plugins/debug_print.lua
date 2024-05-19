return {
  {
    "chrisgrieser/nvim-chainsaw",
    event = "VeryLazy",
    config = true,
    keys = {
      { "<leader>l", "<cmd>lua require('chainsaw').variableLog()<CR>", { desc = "Chainsaw variable log" } },
      { "<leader>lo", "<cmd>lua require('chainsaw').objectLog()<CR>", { desc = "Chainsaw object log" } },
      { "<leader>lm", "<cmd>lua require('chainsaw').messageLog()<CR>", { desc = "Chainsaw message log" } },
      { "<leader>lb", "<cmd>lua require('chainsaw').beepLog()<CR>", { desc = "Chainsaw beep log" } },
      { "<leader>lt", "<cmd>lua require('chainsaw').timeLog()<CR>", { desc = "Chainsaw time log" } },
      { "<leader>ld", "<cmd>lua require('chainsaw').removeLogs()<CR>", { desc = "Chainsaw remove logs" } },
    },
  },
}

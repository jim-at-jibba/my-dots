return {
  {
    "chrisgrieser/nvim-chainsaw",
    event = "VeryLazy",
    config = function()
      require("chainsaw").setup({
        logStatements = {
          objectLog = {
            javascript = 'console.log("%s %s:", JSON.stringify(%s, null, 2));',
            typescript = 'console.log("%s %s:", JSON.stringify(%s, null, 2));',
            typescriptreact = 'console.log("%s %s:", JSON.stringify(%s, null, 2));',
          },
        },
        logEmojis = { "🔵 1:", "🟩 2:", "⭐ 3:", "⭕ 4:", "💜 5:", "🔲 6:" },
      })
    end,
    keys = {
      { "<leader>l", "<cmd>lua require('chainsaw').variableLog()<CR>", { desc = "Chainsaw variable log" } },
      { "<leader>lo", "<cmd>lua require('chainsaw').objectLog()<CR>", { desc = "Chainsaw object log" } },
      { "<leader>lm", "<cmd>lua require('chainsaw').messageLog()<CR>", { desc = "Chainsaw message log" } },
      { "<leader>lb", "<cmd>lua require('chainsaw').emojiLog()<CR>", { desc = "Chainsaw beep log" } },
      { "<leader>lt", "<cmd>lua require('chainsaw').timeLog()<CR>", { desc = "Chainsaw time log" } },
      { "<leader>ld", "<cmd>lua require('chainsaw').removeLogs()<CR>", { desc = "Chainsaw remove logs" } },
    },
  },
}

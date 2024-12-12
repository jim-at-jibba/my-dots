return {
  {
    "chrisgrieser/nvim-chainsaw",
    event = "VeryLazy",
    config = function()
      require("chainsaw").setup({
        marker = "🪚",
        logStatements = {
          objectLog = {
            javascript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
            typescript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
            typescriptreact = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", JSON.stringify({{var}}, null, 2));',
          },
          variableLog = {
            javascript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
            typescript = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
            typescriptreact = 'console.log("{{marker}} {{filename}}({{lnum}}) {{var}}:", {{{var}}});',
          },
        },
        logTypes = {
          emojiLog = {
            emojis = { "🔵 1:", "🟩 2:", "⭐ 3:", "⭕ 4:", "💜 5:", "🔲 6:" },
          },
        },
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

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
          change = {
            hl = "GitSignsChange",
            text = "▍",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
          delete = {
            hl = "GitSignsDelete",
            text = "▸",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          topdelete = {
            hl = "GitSignsDelete",
            text = "▾",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn",
          },
          changedelete = {
            hl = "GitSignsChange",
            text = "▍",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn",
          },
        },
      })
    end,
    keys = {
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk" } },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk" } },
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns blame line" } },
      { "<leader>dt", "<cmd>Gitsigns diffthis<CR>", { desc = "Gitsigns diffthis" } },
      { "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Gitsigns toggle deleted" } },
    },
  },
}

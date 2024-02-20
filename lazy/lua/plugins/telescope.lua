return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", false },
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader><space>", false },
    { "<C-p>", ":Telescope git_files preview=true<CR>", desc = "Fuzzy search (Telescope)" },
  },
}

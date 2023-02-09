return {
  {
    "echasnovski/mini.bufremove",
  -- stylua: ignore
  keys = {
    { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
  },
  },
  {
    "karb94/neoscroll.nvim",
    lazy = true,
    config = true,
  },
}

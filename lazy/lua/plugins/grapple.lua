return {
  {
    "cbochs/grapple.nvim",
    event = "VeryLazy",
    config = function()
      local grapple = require("grapple")
      vim.keymap.set("n", "<leader>hj", function()
        grapple.tag()
      end, { desc = "Add tag to grapple" })
      vim.keymap.set("n", "<leader>hh", function()
        grapple.toggle_tags()
      end, { desc = "Toggle grapple tags menu" })

      vim.keymap.set("n", "<leader>1", function()
        grapple.select({ index = 1 })
      end, { desc = "Select grapple tag at position 1" })
      vim.keymap.set("n", "<leader>2", function()
        grapple.select({ index = 2 })
      end, { desc = "Select grapple tag at position 2" })
      vim.keymap.set("n", "<leader>3", function()
        grapple.select({ index = 3 })
      end, { desc = "Select grapple tag at position 3" })
      vim.keymap.set("n", "<leader>4", function()
        grapple.select({ index = 4 })
      end, { desc = "Select grapple tag at position 4" })

      vim.keymap.set("n", "<leader>5", function()
        grapple.select({ index = 5 })
      end, { desc = "Select grapple tag at position 5" })

      vim.keymap.set("n", "<leader>6", function()
        grapple.select({ index = 6 })
      end, { desc = "Select grapple tag at position 6" })
    end,
  },
}

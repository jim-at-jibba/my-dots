return {
  {
    "cbochs/grapple.nvim",
    event = "VeryLazy",
    config = function()
      local grapple = require("grapple")
      vim.keymap.set("n", "<leader>hj", function()
        grapple.tag()
      end)
      vim.keymap.set("n", "<leader>hh", function()
        grapple.toggle_tags()
      end)

      vim.keymap.set("n", "<leader>1", function()
        grapple.select({ index = 1 })
      end)
      vim.keymap.set("n", "<leader>2", function()
        grapple.select({ index = 2 })
      end)
      vim.keymap.set("n", "<leader>3", function()
        grapple.select({ index = 3 })
      end)
      vim.keymap.set("n", "<leader>4", function()
        grapple.select({ index = 4 })
      end)

      vim.keymap.set("n", "<leader>5", function()
        grapple.select({ index = 5 })
      end)

      vim.keymap.set("n", "<leader>6", function()
        grapple.select({ index = 6 })
      end)
    end,
  },
}

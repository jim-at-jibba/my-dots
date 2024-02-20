local Util = require("lazyvim.util")
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", false },
      {
        "<leader><leader>1",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = Util.root(), position = "right" })
        end,
        desc = "Open Neotree in the root",
      },
    },
  },
}

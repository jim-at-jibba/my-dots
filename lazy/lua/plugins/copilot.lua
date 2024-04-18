return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    keys = {
      { "<leader>nc", "<cmd>CopilotChatToggle<CR>", desc = "Toggle copilot chat window" },
      { "<leader>cR", "<cmd>CopilotChatReset<CR>", desc = "Reset copilot chat window" },
    },
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
      -- window = {
      --   layout = "float",
      --   relative = "cursor",
      --   width = 1,
      --   height = 0.4,
      --   row = 1,
      -- },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}

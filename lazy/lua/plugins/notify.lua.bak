return {
  { -- Notifications
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>ln",
        function()
          local history = require("notify").history()
          if #history == 0 then
            vim.notify("No Notification in this session.", trace, { title = "nvim-notify" })
            return
          end
          local msg = history[#history].message
          vim.fn.setreg("+", msg)
          vim.notify("Last Notification copied.", trace, { title = "nvim-notify" })
        end,
        desc = "󰎟 Copy Last Notification",
      },
    },
    opts = {
      render = "wrapped-compact",
      top_down = false,
      max_width = 72, -- commit message max length
      minimum_width = 15,
      level = vim.log.levels.TRACE, -- minimum severity level
      timeout = 6000,
      stages = "slide", -- slide|fade
      icons = { DEBUG = "", ERROR = "", INFO = "", TRACE = "", WARN = "" },
      on_open = function(win)
        -- set borderstyle
        if not vim.api.nvim_win_is_valid(win) then
          return
        end
      end,
    },
  },
}
